//
//  FavoriteListViewController.swift
//  TesteiOS_Marvel
//
//  Created by Francisco de Carvalho Costa Neto on 22/08/19.
//  Copyright © 2019 Francisco Costa Neto. All rights reserved.
//

import UIKit
import RxSwift

class FavoriteListViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.dataSource = self
            tableView.delegate = self
            tableView.tableFooterView = UIView()
            tableView.register(
                CharacterTableViewCell.nib(),
                forCellReuseIdentifier: CharacterTableViewCell.cellIdentifier)
            
        }
    }
    weak var coordinator: MainCoordinator?
    
    let disposeBag: DisposeBag = DisposeBag()
    let viewModel: FavoriteListViewModel = FavoriteListViewModel()
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.addObstructiveLoading()
        viewModel.rx_loadFavoritesFromDatabase()
            .observeOn(MainScheduler.instance)
            .subscribe(onNext:{ [weak self] _ in
                guard let `self` = self else { return }
                self.removeObstructiveLoading()
                self.tableView.reloadData()
                }, onError: { [weak self] error in
                    guard let `self` = self else { return }
                    self.removeObstructiveLoading()
                    self.presentError(error.localizedDescription, code: "512")
            }).disposed(by: disposeBag)
    }
}

extension FavoriteListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let coordinator = self.coordinator else { return }
        let personaId = viewModel.listOfFavorites[indexPath.row].id
        coordinator.showPersonaDetails(personaId: personaId)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.listOfFavorites.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CharacterTableViewCell.cellIdentifier, for: indexPath) as? CharacterTableViewCell else { return  UITableViewCell() }
        let persona = self.viewModel.listOfFavorites[indexPath.row]
        cell.setView(characterName: persona.name, avatarString: persona.avatar)
        
        return cell
    }
}
