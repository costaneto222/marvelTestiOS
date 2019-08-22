//
//  MarvelCharacterListTests.swift
//  TesteiOS_MarvelTests
//
//  Created by Francisco Costa Neto on 21/08/19.
//  Copyright © 2019 Francisco Costa Neto. All rights reserved.
//

import Quick
import Nimble
import RxSwift

@testable import TesteiOS_Marvel

class MarvelCharacterListTests: QuickSpec {
    override func spec() {
        let viewModel: MarvelCharactersListViewModel = MarvelCharactersListViewModel()
        describe("get list of heroes") {
            it("should bring an array of names and images") {
                let disposeBag = DisposeBag()
                waitUntil { done in
                    viewModel.rx_getAListOfCharacters().subscribe(onNext: {
                        _ in
                        let personas = viewModel.listOfPersonas.map({ (personaName, _) -> String in
                            return personaName
                        })
                        let avatarImages = viewModel.listOfPersonas.map({ (_, avatarString) -> String in
                            return avatarString
                        })
                        expect(personas)
                            .to(equal(["Capitão-América",
                                       "Homem-Aranha",
                                       "Homem de Ferro",
                                       "Viúva Negra",
                                       "Pantera Negra",
                                       "Hulk",
                                       "Thor"]))
                        
                        expect(avatarImages)
                            .to(equal(["",
                                       "",
                                       "",
                                       "",
                                       "",
                                       "",
                                       ""]))
                        done()
                    }).disposed(by: disposeBag)
                }
            }
        }
    }
}
