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
            tableView.tableFooterView = UIView()
            tableView.register(
                CharacterTableViewCell.nib(),
                forCellReuseIdentifier: CharacterTableViewCell.cellIdentifier)
            
        }
    }
    
    let disposeBag: DisposeBag = DisposeBag()
    var viewModel: MarvelCharactersListViewModel = MarvelCharactersListViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addObstructiveLoading()
        self.tableView.isHidden = true
        viewModel.rx_getAListOfCharacters().subscribe(onNext: {
            [weak self] in
            guard let `self` = self else { return }
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
        
        //Todo: Go to char detail screen
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
}
