//
//  ApiServices.swift
//  TesteiOS_Marvel
//
//  Created by Francisco Costa Neto on 20/08/19.
//  Copyright © 2019 Francisco Costa Neto. All rights reserved.
//

import Foundation

class ApiServices {
    static let sharedInstance: ApiServices = ApiServices()
    public var marvelApi: MarvelApiProtocol
    
    public var useMock: Bool = false
    init() {
        marvelApi = useMock ? MarvelApiMock() : MarvelApi()
    }
}
