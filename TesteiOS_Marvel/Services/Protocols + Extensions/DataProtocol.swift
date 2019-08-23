//
//  DataProtocol.swift
//  TesteiOS_Marvel
//
//  Created by Francisco Costa Neto on 21/08/19.
//  Copyright © 2019 Francisco Costa Neto. All rights reserved.
//

import Foundation
import RxSwift

protocol DataModel {
    func savePersonaAsFavorite(_ id: Int, name: String, avatar: String) -> Observable<Bool>
    func retrieveFavoritePersonasList() -> Observable<[(name: String, id: Int, avatar: String)]>
}
