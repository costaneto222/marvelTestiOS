//
//  TesteiOS_MarvelTests.swift
//  TesteiOS_MarvelTests
//
//  Created by Francisco Costa Neto on 20/08/19.
//  Copyright © 2019 Francisco Costa Neto. All rights reserved.
//

import Quick
import Nimble

@testable import TesteiOS_Marvel

class TesteiOS_MarvelTests: QuickSpec {
    override func spec() {
        describe("sample of tests with Quick & Nimble") {
            it ("simple math") {
                expect(1 + 1).to(equal(2))
            }
        }
    }
}
