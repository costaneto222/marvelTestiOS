//
//  MarvelHeroesListViewController.swift
//  TesteiOS_Marvel
//
//  Created by Francisco Costa Neto on 20/08/19.
//  Copyright © 2019 Francisco Costa Neto. All rights reserved.
//

import UIKit
import RxSwift

class MarvelCharactersListViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.dataSource = self
            tableView.delegate = self
            let indicator = UIActivityIndicatorView(style: .gray)
            indicator.startAnimating()
            tableView.tableFooterView = indicator
            tableView.tableFooterView?.isHidden = true
            tableView.register(
                CharacterTableViewCell.nib(),
                forCellReuseIdentifier: CharacterTableViewCell.cellIdentifier)
            
        }
    }
    weak var coordinator: MainCoordinator?
    
    let disposeBag: DisposeBag = DisposeBag()
    var viewModel: MarvelCharactersListViewModel = MarvelCharactersListViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.isHidden = true
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .bookmarks, target: self, action: #selector(showFavoriteList))
        self.addObstructiveLoading()
        self.loadListOfPersonas()
    }
    
    @objc func showFavoriteList() {
        guard let coordinator = coordinator else { return }
        coordinator.showFavoriteList()
    }
    
    func loadListOfPersonas() {
        viewModel.rx_getAListOfCharacters()
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: {
                [weak self] in
                guard let `self` = self else { return }
                self.tableView.tableFooterView?.isHidden = true
                self.tableView.isHidden = false
                self.tableView.reloadData()
                self.removeObstructiveLoading()
                }, onError: { [weak self] error in
                    guard let `self` = self else { return }
                    self.removeObstructiveLoading()
                    self.presentError(error.localizedDescription, code: "402")
            }).disposed(by: disposeBag)
    }
}

extension MarvelCharactersListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let coordinator = self.coordinator else { return }
        let personaId = viewModel.listOfPersonas[indexPath.row].personaId
        coordinator.showPersonaDetails(personaId: personaId)
    }
}

extension MarvelCharactersListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.listOfPersonas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CharacterTableViewCell.cellIdentifier, for: indexPath) as? CharacterTableViewCell else { return  UITableViewCell() }
        let persona = viewModel.listOfPersonas[indexPath.row]
        cell.setView(characterName: persona.personaName, avatarString: persona.avatarString)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let lastrow = (indexPath.row >= viewModel.listOfPersonas.count - 1)
        if lastrow {
            tableView.tableFooterView?.isHidden = false
            self.loadListOfPersonas()
        }
    }
}
