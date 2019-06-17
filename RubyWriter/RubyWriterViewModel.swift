//
//  RubyWriterViewModel.swift
//  RubyWriter
//
//  Created by 中川慶悟 on 2019/06/16.
//  Copyright © 2019 Keigo Nakagawa. All rights reserved.
//

import RxSwift
import RxCocoa

final class RubyWriterViewModel {
    private let disposeBag = DisposeBag()
    private let gooAPIClient: GooAPIProtocol

    init(inputText: Observable<String?>,
         outputText: ControlProperty<String?>,
         isHiragana: ControlProperty<Bool>,
         isKatakana: ControlProperty<Bool>,
         gooAPIClient: GooAPIProtocol = GooAPI()) {
        self.gooAPIClient = gooAPIClient

        var outputType: OutputType = .hiragana // default is hiragana
        isHiragana
            .filter { $0 }
            .subscribe({ _ in
                outputType = .hiragana
            })
            .disposed(by: disposeBag)

        isKatakana
            .filter { $0 }
            .subscribe({ _ in
                outputType = .katakana
            })
            .disposed(by: disposeBag)

        let response = inputText
            .debounce(.seconds(1), scheduler: MainScheduler.instance)
            .observeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .flatMapLatest {
                gooAPIClient.convert(with: $0!, outputType).catchErrorJustReturn(Response.empty)
            }
            .observeOn(MainScheduler.instance)
            .asDriver(onErrorJustReturn: Response.empty)

        response.map {
            $0.converted
            }
            .drive(outputText)
            .disposed(by: disposeBag)
    }
}
