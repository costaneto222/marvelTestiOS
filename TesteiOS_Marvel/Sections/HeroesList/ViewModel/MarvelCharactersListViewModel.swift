//
//  MarvelCharactersListViewModel.swift
//  TesteiOS_Marvel
//
//  Created by Francisco Costa Neto on 20/08/19.
//  Copyright © 2019 Francisco Costa Neto. All rights reserved.
//

import UIKit
import RxSwift

class MarvelCharactersListViewModel {
    var listOfPersonas: [(personaName: String, avatarString: String, personaId: Int)] = []
    private var waitingForCallEnd = false
    func rx_getAListOfCharacters() -> Observable<Void> {
        if waitingForCallEnd {
            return Observable.just(())
        }
        waitingForCallEnd = true
        return ApiServices.sharedInstance.marvelApi.rx_retrieveListOfPersonas().map {
            [weak self] personaList in
            guard let `self` = self else { return }
            self.waitingForCallEnd = false
            self.listOfPersonas = personaList
        }
    }
}
