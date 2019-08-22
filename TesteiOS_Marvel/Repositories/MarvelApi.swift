//
//  MarvelApi.swift
//  TesteiOS_Marvel
//
//  Created by Francisco Costa Neto on 21/08/19.
//  Copyright © 2019 Francisco Costa Neto. All rights reserved.
//

import Foundation
import RxSwift
import CommonCrypto
import CoreData
import Keys

import var CommonCrypto.CC_MD5_DIGEST_LENGTH
import func CommonCrypto.CC_MD5
import typealias CommonCrypto.CC_LONG

func MD5(string: String) -> Data {
    let length = Int(CC_MD5_DIGEST_LENGTH)
    let messageData = string.data(using:.utf8)!
    var digestData = Data(count: length)
    
    _ = digestData.withUnsafeMutableBytes { digestBytes -> UInt8 in
        messageData.withUnsafeBytes { messageBytes -> UInt8 in
            if let messageBytesBaseAddress = messageBytes.baseAddress, let digestBytesBlindMemory = digestBytes.bindMemory(to: UInt8.self).baseAddress {
                let messageLength = CC_LONG(messageData.count)
                CC_MD5(messageBytesBaseAddress, messageLength, digestBytesBlindMemory)
            }
            return 0
        }
    }
    return digestData
}

enum RequestType: String {
    case GET, POST
}

class ApiCalling {
    func get<T: Codable>(apiRequest: URLRequest) -> Observable<T> {
        return Observable<T>.create{ observer in
            let task = URLSession.shared.dataTask(
                with: apiRequest,
                completionHandler: { (data, response, error) in
                    do {
                        let model: T = try JSONDecoder().decode(
                            T.self,
                            from: data ?? Data())
                        observer.onNext(model)
                    } catch let error {
                        observer.onError(error)
                    }
                    observer.onCompleted()
            })
            task.resume()
            return Disposables.create {
                task.cancel()
            }
        }
    }
}

class APIRequest {
    fileprivate static let keys = TesteiOS_MarvelKeys()
    static let privatekey = keys.marvelPrivateKey
    static let apikey = keys.marvelApiKey
    static let ts = Date().timeIntervalSince1970.description
    static let hash = MD5(string: "\(ts)\(privatekey)\(apikey)").map { String(format: "%02hhx", $0) }.joined()
    
    var baseURL: URL { return URL(string: "https://gateway.marvel.com:443")! }
    var method: RequestType = .GET
    var parameters: [String: String] = [:]
    fileprivate(set) var headers: [String: String]?
    
    func request(with baseURL: URL?) -> URLRequest? {
        guard let baseUrl = baseURL else { return nil }
        var request = URLRequest(url: baseUrl)
        request.httpMethod = method.rawValue
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        return request
    }
}

class MarvelApi: MarvelApiProtocol {
    var personaResultModelList: [PersonaModelDataResult] = []
    
    private enum Endpoints: String {
        case getAllPersonas
        
        func call() -> String {
            switch self {
            case .getAllPersonas:
                return "/v1/public/characters?ts=\(APIRequest.ts)&apikey=\(APIRequest.apikey)&hash=\(APIRequest.hash)"
            }
        }
    }
    private let disposeBag: DisposeBag = DisposeBag()
    
    func rx_retrieveListOfPersonas() -> Observable<[(personaName: String, avatarString: String, personaId: Int)]> {
        let apiCalling: ApiCalling = ApiCalling()
        let apiRequest = APIRequest()
        guard let urlForRequest = URL(
            string: apiRequest.baseURL.absoluteString + Endpoints.getAllPersonas.call()),
            let request = apiRequest.request(with: urlForRequest) else {
            return Observable.error(NSError(
                domain: "Error to retrieve list of personas",
                code: 100,
                userInfo: nil))
        }
        let result: Observable<PersonaModel> = apiCalling.get(apiRequest: request)
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
            return Observable.just(returnList)
        })
    }
    
    func rx_retrievePersonaOverview(_ personaId: Int) -> Observable<(avatarString: String, personaBio: String, personaId: Int, personaName: String)> {
        let apiCalling: ApiCalling = ApiCalling()
        let apiRequest = APIRequest()
        guard let urlForRequest = URL(
            string: apiRequest.baseURL.absoluteString + Endpoints.getAllPersonas.call()),
            let request = apiRequest.request(with: urlForRequest) else {
                return Observable.error(NSError(
                    domain: "Error to retrieve persona details",
                    code: 100,
                    userInfo: nil))
        }
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
        
        let result: Observable<PersonaModel> = apiCalling.get(apiRequest: request)
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
