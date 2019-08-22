//
//  PersonaDetailsViewModel.swift
//  TesteiOS_Marvel
//
//  Created by Francisco Costa Neto on 21/08/19.
//  Copyright © 2019 Francisco Costa Neto. All rights reserved.
//

import Foundation
import RxSwift

class PersonaDetailsViewModel {
    var avatarString: String = ""
    var personaId: Int = 0
    var personaName: String = ""
    var personaBio: String = ""

    func savePersonaAsFavorite() -> Observable<Bool> {
        return ApiServices.sharedInstance.marvelApi.savePersonaAsFavorite(personaId: personaId, avatar: avatarString, name: personaName)
    }
    
    func removePersonaFromFavoriteList() -> Observable<Bool> {
        return ApiServices.sharedInstance.marvelApi.removeFavoritePersonaFromList(personaId)
    }
    
    func rx_retrievePersonaOverview() -> Observable<Void> {
        return ApiServices.sharedInstance.marvelApi.rx_retrievePersonaOverview(self.personaId).map {
            [weak self] avatar, bio, _, name -> Void in
            guard let `self` = self else { return }
            self.avatarString = avatar
            self.personaBio = bio
            self.personaName = name
        }
    }
}
