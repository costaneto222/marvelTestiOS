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
    private enum Endpoints {
        typealias RawValue = String
        case getAllPersonas
        case getComicDetails(comicId: Int)
        
        func call() -> String {
            switch self {
            case .getAllPersonas:
                return "/v1/public/characters?ts=\(APIRequest.ts)&apikey=\(APIRequest.apikey)&hash=\(APIRequest.hash)&limit=\(MarvelApi.pageLimit)&offset=\(MarvelApi.currentPage * MarvelApi.pageLimit)"
                
            case .getComicDetails(let comicId):
                return "/v1/public/comics/\(comicId)?ts=\(APIRequest.ts)&apikey=\(APIRequest.apikey)&hash=\(APIRequest.hash)"
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
            self.personaResultModelList.append(contentsOf: results)
            var returnList: [(personaName: String, avatarString: String, personaId: Int)] = []
            
            for result in self.personaResultModelList {
                if let name = result.name,
                    let id = result.id,
                    let thumbnail = result.thumbnail,
                    let imagePath = thumbnail.imageString {
                    returnList.append((personaName: name,
                                       avatarString: imagePath,
                                    personaId: id))
                }
            }
            MarvelApi.currentPage += 1
            return Observable.just(returnList)
        })
    }
    
    func rx_retrievePersonaOverview(_ personaId: Int) -> Observable<(avatarString: String, personaBio: String, personaId: Int, personaName: String, series: CItem?, comics: [Int], events: CItem?, stories: CItem?)> {
        if let personaModel = personaResultModelList.first(where: { $0.id == personaId }) {
            guard let personaName = personaModel.name,
                let thumbnail = personaModel.thumbnail,
                let filePath = thumbnail.imageString,
                let biography = personaModel.descriptionField,
                let comicsItems = personaModel.comics else {
                return Observable.error(NSError(
                    domain: "Error to retrieve persona details",
                    code: 105,
                    userInfo: nil))
            }
            let comicsIds = comicsItems.items?.map({ uriItem -> Int in
                guard let uriString = uriItem.resourceURI else { return -1 }
                if let comicId = uriString.components(separatedBy: "/").last {
                    return Int(comicId) ?? -1
                }
                return -1
            })
            return Observable.just((
                avatarString: filePath,
                personaBio: biography.isEmpty ? "Biography not available :(" : biography,
                personaId: personaId,
                personaName: personaName,
                series: personaModel.series,
                comics: comicsIds ?? [],
                events: personaModel.events,
                stories: personaModel.stories))
        }
        
        let result: Observable<PersonaModel> = ApiCalling.get(endpointPath: Endpoints.getAllPersonas.call())
        return result.flatMap({ personaModel ->  Observable<(avatarString: String, personaBio: String, personaId: Int, personaName: String, series: CItem?, comics: [Int], events: CItem?, stories: CItem?)> in
            guard let data = personaModel.data,
                let results = data.results,
                let resultPersona = results.first(where: { $0.id == personaId }) else {
                    return Observable.error(NSError(domain: "Something wrong durant model parse", code: 102, userInfo: nil))
            }
            
            guard let name = resultPersona.name,
                let id = resultPersona.id,
                let thumbnail = resultPersona.thumbnail,
                let biography = resultPersona.descriptionField,
                let imagePath = thumbnail.imageString,
                let comicsItems = resultPersona.comics else {
                return Observable.error(NSError(domain: "Something wrong durant model parse", code: 103, userInfo: nil))
            }
            let comicsIds = comicsItems.items?.map({ uriItem -> Int in
                guard let uriString = uriItem.resourceURI else { return -1 }
                if let comicId = uriString.components(separatedBy: "/").last {
                    return Int(comicId) ?? -1
                }
                return -1
            })
            return Observable.just((
                avatarString: imagePath,
                personaBio: biography,
                personaId: id,
                personaName: name,
                series: resultPersona.series,
                comics: comicsIds ?? [],
                events: resultPersona.events,
                stories: resultPersona.stories))
        })
    }
    
    func retrieveComicsDetails(comicId: Int) -> Observable<(comicName: String, comicImageString: String, comicPageCount: Int, comicPrice: Double)> {
        let result: Observable<ComicsDetails> = ApiCalling.get(endpointPath: Endpoints.getComicDetails(comicId: comicId).call())
        return result.flatMap({ comicDetails -> Observable<(comicName: String, comicImageString: String, comicPageCount: Int, comicPrice: Double)> in
            guard let comicName = comicDetails.title,
                let thumbnail = comicDetails.thumbnail,
                let comicImageString = thumbnail.imageString,
                let comicPageCount = comicDetails.pageCount,
                let comicPrice = comicDetails.prices else {
                    return Observable.error(NSError(domain: "Something wrong durant parse comic model", code: 104, userInfo: nil))
            }
            return Observable.just(((comicName: comicName,
                                     comicImageString: comicImageString,
                                     comicPageCount: comicPageCount,
                                     comicPrice: 0.0)))
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
