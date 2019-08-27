//
//  PersonaDetailsViewController.swift
//  TesteiOS_Marvel
//
//  Created by Francisco Costa Neto on 21/08/19.
//  Copyright © 2019 Francisco Costa Neto. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

fileprivate enum DetailsRows: Int {
    case overview = 0
    case bio
    
    static let count: Int = {
        var count = 0
        while let _ = DetailsRows(rawValue: count) { count += 1}
        
        return count
    }()
}

class PersonaDetailsViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.dataSource = self
            tableView.separatorStyle = .none
            tableView.register(OverviewHeaderViewCell.nib(),
                               forCellReuseIdentifier: OverviewHeaderViewCell.cellIdentifier)
            tableView.register(BioTableViewCell.nib(),
                               forCellReuseIdentifier: BioTableViewCell.cellIdentifier)
            tableView.tableFooterView = UIView()
        }
    }
    weak var coordinator: MainCoordinator?
    
    let viewModel: PersonaDetailsViewModel = PersonaDetailsViewModel()
    let disposeBag: DisposeBag = DisposeBag()
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.rx_retrievePersonaDetails()
    }
    
    func saveAsFavorite() {
        self.viewModel.savePersonaAsFavorite().subscribe(onNext: {
            [weak self] result in
            guard let `self` = self else { return }
            if result {
                self.presentASuccessAlert(withMessage: "Persona saved successfully")
            } else {
                self.presentError("It was not possible save your data at this time. Try again later", code: "587")
            }
        }, onError: { [weak self] error in
            guard let `self` = self else { return }
            self.presentError(error.localizedDescription, code: "511")
        }).disposed(by: self.disposeBag)
    }
    
    func rx_retrievePersonaDetails() {
        self.addObstructiveLoading()
        viewModel.rx_retrievePersonaOverview()
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: {
                [weak self] _ in
                guard let `self` = self else { return }
                self.removeObstructiveLoading()
                self.tableView.reloadData()
            }, onError: { [weak self] error in
                guard let `self` = self else { return }
                self.removeObstructiveLoading()
                self.presentError(error.localizedDescription, code: "150")
            }).disposed(by: self.disposeBag)
    }
    
//    func reloadPersonaInformationForType(_ index: Int) {
//
//    }
}

extension PersonaDetailsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DetailsRows.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case DetailsRows.overview.rawValue:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: OverviewHeaderViewCell.cellIdentifier, for: indexPath) as? OverviewHeaderViewCell else { return UITableViewCell() }
            cell.configOverviewWith(avatarImage: viewModel.avatarString)
            cell.favoriteButton.rx.tap.subscribe(onNext: {
                [weak self] in
                guard let `self` = self else { return }
                self.saveAsFavorite()
            }).disposed(by: cell.disposeBag)
            return cell
            
        case DetailsRows.bio.rawValue:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: BioTableViewCell.cellIdentifier, for: indexPath) as? BioTableViewCell else { return UITableViewCell() }
            
            cell.setPersonaBiography(self.viewModel.personaBio)
            return cell
            
        default:
            return UITableViewCell()
        }
    }
}
