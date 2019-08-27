//
//  PersonaDetailsViewModel.swift
//  TesteiOS_Marvel
//
//  Created by Francisco Costa Neto on 21/08/19.
//  Copyright © 2019 Francisco Costa Neto. All rights reserved.
//

import Foundation
import RxSwift

struct ComicsViewModel {
    var name: String = ""
    var image: String = ""
    var pageCount: Int = 0
    var price: Double = 0.0
}

class PersonaDetailsViewModel {
    var avatarString: String = ""
    var personaId: Int = 0
    var personaName: String = ""
    var personaBio: String = ""
    var comicsIds: [Int] = []
    var comics: [ComicsViewModel] = []

    func savePersonaAsFavorite() -> Observable<Bool> {
        return ApiServices.sharedInstance.marvelApi.savePersonaAsFavorite(personaId: personaId, avatar: avatarString, name: personaName)
    }
    
    func removePersonaFromFavoriteList() -> Observable<Bool> {
        return ApiServices.sharedInstance.marvelApi.removeFavoritePersonaFromList(personaId)
    }
    
    func rx_retrievePersonaOverview() -> Observable<Void> {
        self.comics = []
        return ApiServices.sharedInstance.marvelApi.rx_retrievePersonaOverview(self.personaId).flatMap({
            [weak self] avatar, bio, _, name, series, comicsIds, events, stories -> Observable<Void> in
            guard let `self` = self else { return Observable.just(()) }
            self.avatarString = avatar
            self.personaBio = bio
            self.personaName = name
            self.comicsIds = comicsIds
            
            return Observable.just(())
        }).flatMap({ _ -> Observable<Void> in
            let first = self.comicsIds.removeFirst()
            return self.rx_retrieveComicsDetails(comicId: first)
        }).replay(self.comics.count)
    }
    
    func rx_retrieveComicsDetails(comicId: Int) -> Observable<Void> {
        return ApiServices.sharedInstance.marvelApi.retrieveComicsDetails(comicId: comicId).map({ [weak self] (name, image, pageCount, price) -> Void in
            guard let `self` = self else { return }
            self.comics.append(ComicsViewModel(name: name,
                                               image: image,
                                               pageCount: pageCount,
                                               price: price))
        })
    }
}
