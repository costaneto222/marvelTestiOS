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
    static let hash = "\(ts)\(privatekey)\(apikey)"
    
    var baseURL: URL { return URL(string: "https://gateway.marvel.com:443")! }
    var method: RequestType = .GET
    var parameters: [String: String] = [:]
    
    func request(with baseURL: URL?) -> URLRequest? {
        guard let baseUrl = baseURL else { return nil }
        var request = URLRequest(url: baseUrl)
        request.httpMethod = method.rawValue
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        return request
    }
}

struct MarvelApi: MarvelApiProtocol {
    private enum Endpoints: String {
        case getAllPersonas
        
        func call() -> String {
            switch self {
            case .getAllPersonas:
                return "/v1/public/characters"
            }
        }
    }
    private let apiCalling: ApiCalling = ApiCalling()
    private let disposeBag: DisposeBag = DisposeBag()
    
    func rx_retrieveListOfPersonas() -> Observable<[(personaName: String, avatarString: String)]> {
        let apiRequest = APIRequest()
        apiRequest.parameters = ["apikey": APIRequest.apikey,
                                 "ts": APIRequest.ts,
                                 "hash": APIRequest.hash]
        guard let urlForRequest = URL(
            string: apiRequest.baseURL.absoluteString + Endpoints.getAllPersonas.call()),
            let request = apiRequest.request(with: urlForRequest) else {
            return Observable.error(NSError(
                domain: "Error to retrieve list of personas",
                code: 100,
                userInfo: nil))
        }
        let result: Observable<PersonaModel> = apiCalling.get(apiRequest: request)
        return result.flatMap({ personaModel ->  Observable<[(personaName: String, avatarString: String)]> in
            guard let data = personaModel.data,
                let results = data.results else {
                    return Observable.error(NSError(domain: "Something wrong durant model parse", code: 102, userInfo: nil))
            }
            let listOfPersonas = results
            var returnList: [(personaName: String, avatarString: String)] = []
            
            for result in listOfPersonas {
                if let name = result.name,
                    let thumbnail = result.thumbnail,
                    let filePath = thumbnail.path {
                    returnList.append((personaName: name, avatarString: filePath))
                }
            }
            return Observable.just(returnList)
        })
    }
    
    func rx_retrievePersonaOverview(_ personaId: Int) -> Observable<(avatarString: String, personaBio: String, personaId: Int, personaName: String)> {
        return Observable.error(NSError(
            domain: "Error to retrieve list of personas",
            code: 100,
            userInfo: nil))
    }
    
    func savePersonaAsFavorite(personaId: Int, avatar: Data, name: String) -> Observable<Bool> {
        return Observable.error(NSError(
            domain: "Error to retrieve list of personas",
            code: 100,
            userInfo: nil))
    }
    
    func retrieveListOfFavoritesPersonas() -> Observable<[(name: String, id: Int, avatar: Data?)]> {
        return Observable.error(NSError(
            domain: "Error to retrieve list of personas",
            code: 100,
            userInfo: nil))
    }
    
    func removeFavoritePersonaFromList(_ personaId: Int) -> Observable<Bool> {
        return Observable.error(NSError(
            domain: "Error to retrieve list of personas",
            code: 100,
            userInfo: nil))
    }
    

}
