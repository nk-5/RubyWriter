//
//  GooAPI.swift
//  RubyWriter
//
//  Created by 中川慶悟 on 2019/06/15.
//  Copyright © 2019 Keigo Nakagawa. All rights reserved.
//

import Foundation
import RxSwift
import RxAlamofire
import Alamofire

enum OutputType: String {
    case hiragana
    case katakana
}

typealias Handler = (Swift.Result<String, Error>) -> Void

protocol GooAPIProtocol {
    func convert(with sentence: String, _ type: OutputType, completionHandler: @escaping Handler)
}

struct GooAPI: GooAPIProtocol {
    private var session: SessionManager
    private var baseURL: String
    private var disposeBag: DisposeBag
    private var appId: String?

    init() {
        self.session = SessionManager.default
        self.baseURL = "https://labs.goo.ne.jp/api/hiragana"
        self.disposeBag = DisposeBag()
        guard let path = Bundle.main.path(forResource: "GooConfig", ofType: "txt") else {
            precondition(false, "goo config file not found and need goo app id. try make prepare GOO_APP_ID=[app_id]")
        }

        do {
            self.appId = try String(contentsOfFile: path, encoding: .utf8)
            self.appId = self.appId!.components(separatedBy: "\n")[0]
        } catch {
            precondition(false, "\(error)")
        }
    }

    func convert(with sentence: String, _ type: OutputType, completionHandler: @escaping Handler) {
        _ = self.session.rx.json(.post, self.baseURL, parameters: [
            "app_id": self.appId!,
            "sentence": sentence,
            "output_type": type])
            .subscribe(onNext: {
                print($0)
                completionHandler(.success(""))
            }, onError: { error in
                completionHandler(.failure(error))
            })
            .disposed(by: self.disposeBag)
    }
}
