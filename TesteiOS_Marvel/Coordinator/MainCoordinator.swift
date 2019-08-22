//
//  MainCoordinator.swift
//  TesteiOS_Marvel
//
//  Created by Francisco Costa Neto on 20/08/19.
//  Copyright © 2019 Francisco Costa Neto. All rights reserved.
//

import UIKit

class MainCoordinator: Coordinator {
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let vc = MarvelCharactersListViewController.instantiate(fromStoryboard: "Main")
        vc.coordinator = self
        navigationController.pushViewController(vc, animated: false)
    }
    
    func showPersonaDetails(personaId: Int) {
        let vc = PersonaDetailsViewController.instantiate(fromStoryboard: "Main")
        vc.coordinator = self
        vc.viewModel.personaId = personaId
        navigationController.pushViewController(vc, animated: false)
    }
    
    func showFavoriteList() {
        let vc = FavoriteListViewController.instantiate(fromStoryboard: "Main")
        vc.coordinator = self
        navigationController.pushViewController(vc, animated: false)
    }
}
