//
//  GooAPITests.swift
//  RubyWriterTests
//
//  Created by 中川慶悟 on 2019/06/16.
//  Copyright © 2019 Keigo Nakagawa. All rights reserved.
//

import XCTest
@testable import RubyWriter

class GooAPITests: XCTestCase {

    private var gooAPIClient: GooAPI = GooAPI()

    override func setUp() {
        //        gooAPIClient = GooAPI()
    }

    override func tearDown() {
    }

    func testConvert() {
        let expectation = self.expectation(description: #function)
        gooAPIClient.convert(with: "中川", .hiragana, completionHandler: {(result) in
            switch result {
            case .success(let val):
                print(val)
                XCTAssertEqual("なかがわ", val)
            case .failure(let err):
                print(err)
                XCTAssertNil(err)
            }
            expectation.fulfill()
        })
        waitForExpectations(timeout: 3)
    }
}
