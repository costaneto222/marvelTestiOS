//
//  FavoriteListViewModel.swift
//  TesteiOS_Marvel
//
//  Created by Francisco de Carvalho Costa Neto on 22/08/19.
//  Copyright © 2019 Francisco Costa Neto. All rights reserved.
//

import Foundation
import RxSwift

class FavoriteListViewModel {
    var listOfFavorites: [(name: String, id: Int, avatar: String)] = []
    
    func rx_loadFavoritesFromDatabase() -> Observable<Void> {
        return ApiServices.sharedInstance.marvelApi.retrieveListOfFavoritesPersonas().map { list -> Void in
            self.listOfFavorites = list
            return
        }
    }
}
