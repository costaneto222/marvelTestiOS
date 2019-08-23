//
//  MarvelApi.swift
//  TesteiOS_Marvel
//
//  Created by Francisco Costa Neto on 21/08/19.
//  Copyright © 2019 Francisco Costa Neto. All rights reserved.
//

import Foundation
import RxSwift

class MarvelApi: MarvelApiProtocol {
    var personaResultModelList: [PersonaModelDataResult] = []
    fileprivate static var currentPage: Int = 0
    fileprivate static var pageLimit: Int = 20
    private enum Endpoints: String {
        case getAllPersonas
        
        func call() -> String {
            switch self {
            case .getAllPersonas:
                return "/v1/public/characters?ts=\(APIRequest.ts)&apikey=\(APIRequest.apikey)&hash=\(APIRequest.hash)&limit=\(MarvelApi.pageLimit)&offset=\(MarvelApi.currentPage * MarvelApi.pageLimit)"
            }
        }
    }
    private let disposeBag: DisposeBag = DisposeBag()
    
    func rx_retrieveListOfPersonas() -> Observable<[(personaName: String, avatarString: String, personaId: Int)]> {
        let result: Observable<PersonaModel> = ApiCalling.get(endpointPath: Endpoints.getAllPersonas.call())
        return result.flatMap({ [weak self] personaModel ->  Observable<[(personaName: String, avatarString: String, personaId: Int)]> in
            guard let `self` = self,
                let data = personaModel.data,
                let results = data.results else {
                    return Observable.error(NSError(domain: "Something wrong durant model parse", code: 102, userInfo: nil))
            }
            self.personaResultModelList = results
            var returnList: [(personaName: String, avatarString: String, personaId: Int)] = []
            
            for result in self.personaResultModelList {
                if let name = result.name,
                    let id = result.id,
                    let thumbnail = result.thumbnail,
                    let imagePath = thumbnail.path,
                    let imageExtension = thumbnail.fileExtension {
                    returnList.append((personaName: name,
                                       avatarString: "\(imagePath).\(imageExtension)",
                                    personaId: id))
                }
            }
            MarvelApi.currentPage += 1
            return Observable.just(returnList)
        })
    }
    
    func rx_retrievePersonaOverview(_ personaId: Int) -> Observable<(avatarString: String, personaBio: String, personaId: Int, personaName: String)> {
        if let personaModel = personaResultModelList.first(where: { $0.id == personaId }) {
            guard let personaName = personaModel.name,
                let thumbnail = personaModel.thumbnail,
                let filePath = thumbnail.path,
                let fileExtension = thumbnail.fileExtension,
                let biography = personaModel.descriptionField else {
                return Observable.error(NSError(
                    domain: "Error to retrieve persona details",
                    code: 105,
                    userInfo: nil))
            }
            return Observable.just((
                avatarString: "\(filePath).\(fileExtension)",
                personaBio: biography,
                personaId: personaId,
                personaName: personaName))
        }
        
        let result: Observable<PersonaModel> = ApiCalling.get(endpointPath: Endpoints.getAllPersonas.call())
        return result.flatMap({ personaModel ->  Observable<(avatarString: String, personaBio: String, personaId: Int, personaName: String)> in
            guard let data = personaModel.data,
                let results = data.results,
                let resultPersona = results.first(where: { $0.id == personaId }) else {
                    return Observable.error(NSError(domain: "Something wrong durant model parse", code: 102, userInfo: nil))
            }
            
            guard let name = resultPersona.name,
                let id = resultPersona.id,
                let thumbnail = resultPersona.thumbnail,
                let biography = resultPersona.descriptionField,
                let imagePath = thumbnail.path,
                let imageExtension = thumbnail.fileExtension else {
                return Observable.error(NSError(domain: "Something wrong durant model parse", code: 103, userInfo: nil))
            }
            return Observable.just((
                avatarString: "\(imagePath).\(imageExtension)",
                personaBio: biography,
                personaId: id,
                personaName: name))
        })
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
