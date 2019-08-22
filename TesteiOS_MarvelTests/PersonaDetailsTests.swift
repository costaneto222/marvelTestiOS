//
//  PersonaDetailsTests.swift
//  TesteiOS_MarvelTests
//
//  Created by Francisco Costa Neto on 21/08/19.
//  Copyright © 2019 Francisco Costa Neto. All rights reserved.
//

import Quick
import Nimble
import RxSwift

@testable import TesteiOS_Marvel

class PersonaDetailsTests: QuickSpec {
    override func spec() {
        let viewModel: PersonaDetailsViewModel = PersonaDetailsViewModel()
        describe("get persona details") {
            it("should bring a persona image and biography") {
                let disposeBag: DisposeBag = DisposeBag()
                waitUntil { done in
                    viewModel.rx_retrievePersonaOverview().subscribe(onNext: {
                        _ in
                        expect(viewModel.avatarString).to(equal(""))
                        expect(viewModel.personaBio).to(equal("Descrição sobre a origem do personagem"))
                        done()
                    }).disposed(by: disposeBag)
                }
            }
        }
    }
}
