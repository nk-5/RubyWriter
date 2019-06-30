//
//  GooAPITests.swift
//  RubyWriterTests
//
//  Created by 中川慶悟 on 2019/06/16.
//  Copyright © 2019 Keigo Nakagawa. All rights reserved.
//

import XCTest
import RxTest
import RxBlocking
import Mockingjay

@testable import RubyWriter

class GooAPITests: XCTestCase {

    private var gooAPIClient: GooAPI = GooAPI(appId: "test")

    override func setUp() {
    }

    func testConvertHiragana() {
        let json = "{\"converted\": \"なかがわ\", \"output_type\": \"hiragana\", \"request_id\": \"hoge\"}"
        stub(http(.post, uri: "https://labs.goo.ne.jp/api/hiragana"), jsonData(json.data(using: .utf8)!))

        let res = try? gooAPIClient.convert(with: "中川", .hiragana).toBlocking().single()
        XCTAssertEqual(res?.converted, "なかがわ")
    }

    func testConvertKatakana() {
        let json = "{\"converted\": \"ナカガワ\", \"output_type\": \"katakana\", \"request_id\": \"hoge\"}"
        stub(http(.post, uri: "https://labs.goo.ne.jp/api/hiragana"), jsonData(json.data(using: .utf8)!))

        let res = try? gooAPIClient.convert(with: "中川", .katakana).toBlocking().single()
        XCTAssertEqual(res?.converted, "ナカガワ")
    }
}
