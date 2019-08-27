//
//  MarvelApiMock.swift
//  TesteiOS_Marvel
//
//  Created by Francisco Costa Neto on 20/08/19.
//  Copyright © 2019 Francisco Costa Neto. All rights reserved.
//

import Foundation
import RxSwift
import CoreData

struct MarvelApiMock: MarvelApiProtocol {
    var entities: [NSManagedObject] = []
    var listOfPersonas: [(personaName: String, avatarString: String, personaId: Int, personaBio: String)] = [
        (personaName: "Capitão-América", avatarString: "", personaId: 0, personaBio: "Biografia"),
        (personaName: "Homem-Aranha", avatarString: "", personaId: 1, personaBio: "Biografia"),
        (personaName: "Homem de Ferro", avatarString: "", personaId: 2, personaBio: "Biografia"),
        (personaName: "Viúva Negra", avatarString: "", personaId: 3, personaBio: "Biografia"),
        (personaName: "Pantera Negra", avatarString: "", personaId: 4, personaBio: "Biografia"),
        (personaName: "Hulk", avatarString: "", personaId: 5, personaBio: "Biografia"),
        (personaName: "Thor", avatarString: "", personaId: 6, personaBio: "Biografia")]
    
    func rx_retrieveListOfPersonas() -> Observable<[(personaName: String, avatarString: String, personaId: Int)]> {
        let listToReturn = listOfPersonas.map {
            name, avatar, id, bio -> (personaName: String, avatarString: String, personaId: Int) in
            return (personaName: name, avatarString: avatar, personaId: id)
        }
        return Observable
            .just(listToReturn)
            .delay(.milliseconds(500), scheduler: MainScheduler.instance)
    }
    
    func rx_retrievePersonaOverview(_ personaId: Int) -> Observable<(avatarString: String, personaBio: String, personaId: Int, personaName: String, series: CItem?, comics: [Int], events: CItem?, stories: CItem?)> {
        guard let returnValue = listOfPersonas.first(where: { $0.personaId == personaId }) else { return Observable.error(NSError(domain: "persona id not found", code: 3, userInfo: nil)) }
        
        return Observable.just((
            avatarString: returnValue.avatarString,
            personaBio: returnValue.personaBio,
            personaId: personaId,
            personaName: returnValue.personaName,
            series: nil,
            comics: [],
            events: nil,
            stories: nil))
    }
    
    func retrieveComicsDetails(comicId: Int) -> Observable<(comicName: String, comicImageString: String, comicPageCount: Int, comicPrice: Double)> {
        return Observable.just((comicName: "Os vingadores",
                               comicImageString: "Imagem.jpg",
                               comicPageCount: 50,
                               comicPrice: 4.99))
    }
    
    func savePersonaAsFavorite(personaId: Int, avatar: String, name: String) -> Observable<Bool> {
        return CoreDataModel.sharedInstance.savePersonaAsFavorite(personaId, name: name, avatar: avatar)
    }
    
    func retrieveListOfFavoritesPersonas() -> Observable<[(name: String, id: Int, avatar: String)]> {
        return CoreDataModel.sharedInstance.retrieveFavoritePersonasList()
    }
    
    func removeFavoritePersonaFromList(_ personaId: Int) -> Observable<Bool> {
        return CoreDataModel.sharedInstance.removePersonaFromFavoriteList(personaId)
    }
}
