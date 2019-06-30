//
//  RubyWriterViewController.swift
//  RubyWriter
//
//  Created by 中川慶悟 on 2019/06/16.
//  Copyright © 2019 Keigo Nakagawa. All rights reserved.
//

import UIKit
import RxSwift
import SwiftIconFont
import NVActivityIndicatorView

class RubyWriterViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var toHiraganaSwitch: UISwitch!
    @IBOutlet weak var toKatakanaSwitch: UISwitch!
    @IBOutlet weak var input: UITextField!
    @IBOutlet weak var output: UITextField!
    @IBOutlet weak var convertArrow: UIImageView!
    @IBOutlet weak var loading: NVActivityIndicatorView!

    private var viewModel: RubyWriterViewModel?
    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        convertArrow.setIcon(from: .octicon, code: "arrow-down")
        input.delegate = self

        let inputText = input.rx.controlEvent(.editingChanged)
            .map { self.input.text }

        viewModel = RubyWriterViewModel(inputText: inputText,
                                        hiraganaSwitch: toHiraganaSwitch.rx,
                                        katakanaSwitch: toKatakanaSwitch.rx)

        viewModel?.output
            .asDriver(onErrorJustReturn: "error")
            .drive(output.rx.text)
            .disposed(by: disposeBag)

        viewModel?.loading
            .asDriver(onErrorJustReturn: false)
            .map { isLoading in
                if isLoading {
                    self.loading.startAnimating()
                } else {
                    self.loading.stopAnimating()
                }
                return !isLoading
            }
            .drive(loading.rx.isHidden)
            .disposed(by: disposeBag)

        viewModel?.loading
            .asDriver(onErrorJustReturn: false)
            .drive(convertArrow.rx.isHidden)
            .disposed(by: disposeBag)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if input.resignFirstResponder() {
            input.resignFirstResponder()
        }
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
