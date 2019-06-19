//
//  RubyWriterViewModel.swift
//  RubyWriter
//
//  Created by 中川慶悟 on 2019/06/16.
//  Copyright © 2019 Keigo Nakagawa. All rights reserved.
//

import RxSwift
import RxCocoa
import Firebase

final class RubyWriterViewModel {
    private let disposeBag = DisposeBag()
    private let gooAPIClient: GooAPIProtocol
    private let textRecognizer: VisionTextRecognizer

    init(inputText: Observable<String?>,
         outputText: ControlProperty<String?>,
         hiraganaSwitch: Reactive<UISwitch>,
         katakanaSwitch: Reactive<UISwitch>,
         gooAPIClient: GooAPIProtocol = GooAPI()) {
        self.gooAPIClient = gooAPIClient
        let vision = Vision.vision()
        textRecognizer = vision.onDeviceTextRecognizer()

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

    func recognizeTextFrom(original: UIImage, completionHandler: @escaping () -> Void) {
        let image = VisionImage(image: original)
        textRecognizer.process(image, completion: { result, error in
            guard error == nil, let result = result else {
                // TODO: error message
                print("text recognizer error")
                completionHandler()
                return
            }

            print("recognized!!")
            print(result.text)
            completionHandler()
        })
    }
}
