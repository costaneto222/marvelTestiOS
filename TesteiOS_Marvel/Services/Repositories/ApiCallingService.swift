//
//  ApiCallingService.swift
//  TesteiOS_Marvel
//
//  Created by Francisco de Carvalho Costa Neto on 23/08/19.
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
    static func get<T: Codable>(endpointPath: String) -> Observable<T> {
        let apiRequest = APIRequest()
        guard let request = apiRequest.request(with: URL(
                string: apiRequest.baseURL.absoluteString + endpointPath)) else {
                return Observable<T>.error(NSError(
                    domain: "Error to retrieve list of personas",
                    code: 100,
                    userInfo: nil))
        }
        print("\(apiRequest.method.rawValue) - \(request.description)")
        return Observable<T>.create{ observer in
            let task = URLSession.shared.dataTask(
                with: request, completionHandler: { (data, response, error) in
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
