//
//  CoreDataTests.swift
//  TesteiOS_MarvelTests
//
//  Created by Francisco Costa Neto on 21/08/19.
//  Copyright © 2019 Francisco Costa Neto. All rights reserved.
//

import Quick
import Nimble
import CoreData
import RxSwift

@testable import TesteiOS_Marvel

class CoreDataTests: QuickSpec {
    override func spec() {
        let disposeBag: DisposeBag = DisposeBag()
        describe("when persona was saved as favorite") {
            it("should save a minimum favorite persona details locally") {
                let avatarData = "avatarURLString"
                let personaId = -54321
                let personaName = "personUnitTestName"
                waitUntil { done in
                    _ = CoreDataModel.sharedInstance.savePersonaAsFavorite(
                        personaId,
                        name: personaName,
                        avatar: avatarData).subscribe(onNext: { callResult -> Void in
                            expect(callResult).to(equal(true))
                            done()
                        }).disposed(by: disposeBag)
                }
            }
        }
        
        describe("persona that was saved") {
            it("should be in list of personas") {
                waitUntil { done in
                    _ = CoreDataModel.sharedInstance.retrieveFavoritePersonasList().subscribe(onNext: {
                        personaList -> Void in
                        if let first = personaList.first(where: { $0.id == -54321 }) {
                            expect(first.name).to(equal("personUnitTestName"))
                            expect(first.avatar).to(equal("avatarURLString"))
                            expect(first.id).to(equal(-54321))
                        }
                        done()
                    }).disposed(by: disposeBag)
                }
            }
        }
        
        describe("remove persona") {
            it("should remove persona successfully") {
                waitUntil { done in
                    _ = CoreDataModel.sharedInstance.removePersonaFromFavoriteList(-54321).subscribe(onNext: { callResult -> Void in
                        expect(callResult).to(equal(true))
                        done()
                    }).disposed(by: disposeBag)
                }
            }
        }
    }
}
