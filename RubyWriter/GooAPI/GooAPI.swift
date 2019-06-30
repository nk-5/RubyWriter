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

enum Errors: Error {
    case requestFailed
}

protocol GooAPIProtocol {
    func convert(with sentence: String, _ type: OutputType) -> Observable<Response>
}

struct Response: Codable {
    var converted: String
    var outputType: String
    var requestId: String

    static let empty = Response(converted: "", outputType: "hiragana", requestId: "")
}

class GooAPI: GooAPIProtocol {
    private var session: SessionManager
    private var baseURL: String
    private var disposeBag: DisposeBag
    private var appId: String?

    init(appId: String? = nil) {
        self.session = SessionManager.default
        self.baseURL = "https://labs.goo.ne.jp/api/hiragana"
        self.disposeBag = DisposeBag()
        guard let path = Bundle.main.path(forResource: "GooConfig", ofType: "txt") else {
            precondition(false, "goo config file not found and need goo app id. try make prepare GOO_APP_ID=[app_id]")
        }

        if let id = appId {
            self.appId = id
            return
        }

        do {
            self.appId = try String(contentsOfFile: path, encoding: .utf8)
            self.appId = self.appId!.components(separatedBy: "\n")[0]
        } catch {
            precondition(false, "\(error)")
        }
    }

    func convert(with sentence: String, _ type: OutputType) -> Observable<Response> {
        return Observable.create { [weak self] observer in
            self?.session.rx.request(.post, self!.baseURL, parameters: [
                "app_id": self!.appId!,
                "sentence": sentence,
                "output_type": type])
                .validate(statusCode: 200..<300)
                .validate(contentType: ["application/json"])
                .responseJSON()
                .subscribe(onNext: {
                    let jsonDecoder = JSONDecoder()
                    jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
                    guard let res = try? jsonDecoder.decode(Response.self, from: $0.data!) else {
                        observer.onError(Errors.requestFailed)
                        return
                    }
                    observer.onNext(res)
                    observer.onCompleted()
                }, onError: { error in
                    observer.onError(error)
                })
                .disposed(by: self!.disposeBag)

            return Disposables.create()
        }
    }
}
