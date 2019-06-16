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
        _ = gooAPIClient.convert(with: "中川", .hiragana)
            .subscribe(onNext: { res in
                XCTAssertEqual("なかがわ", res.converted)
                expectation.fulfill()
            }, onError: { err in
                XCTAssertNil(err)
            })
        waitForExpectations(timeout: 3)
    }

    func testConvertKatakana() {
        let expectation = self.expectation(description: #function)
        _ = gooAPIClient.convert(with: "中川", .katakana)
            .subscribe(onNext: { res in
                XCTAssertEqual("ナカガワ", res.converted)
                expectation.fulfill()
            }, onError: { err in
                XCTAssertNil(err)
            })
        waitForExpectations(timeout: 3)
    }
}
