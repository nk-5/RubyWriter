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
    }

    func testConvertHiragana() {
        let expectation = self.expectation(description: #function)
        gooAPIClient.convert(with: "中川", .hiragana, completionHandler: {(result) in
            switch result {
            case .success(let val):
                print(val)
                XCTAssertEqual("なかがわ", val.converted)
            case .failure(let err):
                print(err)
                XCTAssertNil(err)
            }
            expectation.fulfill()
        })
        waitForExpectations(timeout: 3)
    }

    func testConvertKatakana() {
        let expectation = self.expectation(description: #function)
        gooAPIClient.convert(with: "中川", .katakana, completionHandler: {(result) in
            switch result {
            case .success(let val):
                print(val)
                XCTAssertEqual("ナカガワ", val.converted)
            case .failure(let err):
                print(err)
                XCTAssertNil(err)
            }
            expectation.fulfill()
        })
        waitForExpectations(timeout: 3)
    }
}
