//
//  MarvelApiProtocol.swift
//  TesteiOS_Marvel
//
//  Created by Francisco Costa Neto on 20/08/19.
//  Copyright © 2019 Francisco Costa Neto. All rights reserved.
//

import Foundation
import RxSwift

protocol MarvelApiProtocol {
    func rx_retrieveListOfPersonas() -> Observable<[(personaName: String, avatarString: String)]>
    func rx_retrievePersonaOverview(_ personaId: Int) -> Observable<(avatarString: String, personaBio: String, personaId: Int, personaName: String)>
    func savePersonaAsFavorite(personaId: Int, avatar: Data, name: String) -> Observable<Bool>
    func retrieveListOfFavoritesPersonas() -> Observable<[(name: String, id: Int, avatar: Data?)]>
    func removeFavoritePersonaFromList(_ personaId: Int) -> Observable<Bool>
}
