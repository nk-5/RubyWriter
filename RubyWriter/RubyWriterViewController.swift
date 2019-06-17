//
//  RubyWriterViewController.swift
//  RubyWriter
//
//  Created by 中川慶悟 on 2019/06/16.
//  Copyright © 2019 Keigo Nakagawa. All rights reserved.
//

import UIKit
import RxSwift

class RubyWriterViewController: UIViewController {
    @IBOutlet weak var toHiraganaSwitch: UISwitch!
    @IBOutlet weak var toKatakanaSwitch: UISwitch!
    @IBOutlet weak var input: UITextField!
    @IBOutlet weak var output: UITextField!

    private var viewModel: RubyWriterViewModel?
    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        let inputText = input.rx.controlEvent(.editingChanged)
            .map { self.input.text }
            .filter {($0 ?? "").count > 0}

        viewModel = RubyWriterViewModel(inputText: inputText,
                                        outputText: output.rx.text,
                                        hiraganaSwitch: toHiraganaSwitch.rx,
                                        katakanaSwitch: toKatakanaSwitch.rx)
    }
}
