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
    private let loadingSubject = PublishSubject<Bool>()
    var loading: Observable<Bool> { return loadingSubject }

    init(inputText: Observable<String?>,
         outputText: ControlProperty<String?>,
         hiraganaSwitch: Reactive<UISwitch>,
         katakanaSwitch: Reactive<UISwitch>,
         gooAPIClient: GooAPIProtocol = GooAPI()) {
        self.gooAPIClient = gooAPIClient
        var outputType: OutputType = .hiragana // default is hiragana

        hiraganaSwitch.isOn.changed
            .map { !$0 }
            .asDriver(onErrorJustReturn: false)
            .drive(katakanaSwitch.isOn)
            .disposed(by: disposeBag)

        katakanaSwitch.isOn.changed
            .map { !$0 }
            .asDriver(onErrorJustReturn: false)
            .drive(hiraganaSwitch.isOn)
            .disposed(by: disposeBag)

        hiraganaSwitch.isOn
            .filter { $0 }
            .subscribe({ _ in
                outputType = .hiragana
            })
            .disposed(by: disposeBag)

        katakanaSwitch.isOn
            .filter { $0 }
            .subscribe({ _ in
                outputType = .katakana
            })
            .disposed(by: disposeBag)

        let response = inputText
            .debounce(.seconds(1), scheduler: MainScheduler.instance)
            .filter {($0 ?? "").count > 0}
            .observeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .flatMapLatest {
                gooAPIClient
                    .convert(with: $0!, outputType)
                    .catchErrorJustReturn(Response.empty)
            }
            .observeOn(MainScheduler.instance)
            .asDriver(onErrorJustReturn: Response.empty)

        response
            .map {
                self.loadingSubject.onNext(false)
                return $0.converted
            }
            .drive(outputText)
            .disposed(by: disposeBag)

        inputText
            .debounce(.seconds(1), scheduler: MainScheduler.instance)
            .map {($0 ?? "").count > 0}
            .subscribe(onNext: {
                self.loadingSubject.onNext($0)
            })
            .disposed(by: disposeBag)

        // set empty for output text if input text changed empty
        inputText
            .debounce(.seconds(1), scheduler: MainScheduler.instance)
            .filter {($0 ?? "").count == 0}
            .asDriver(onErrorJustReturn: "error")
            .drive(outputText)
            .disposed(by: disposeBag)
    }
}
