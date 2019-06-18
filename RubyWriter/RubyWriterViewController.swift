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

class RubyWriterViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet weak var toHiraganaSwitch: UISwitch!
    @IBOutlet weak var toKatakanaSwitch: UISwitch!
    @IBOutlet weak var input: UITextField!
    @IBOutlet weak var output: UITextField!
    @IBOutlet weak var camera: UIImageView!

    private var viewModel: RubyWriterViewModel?
    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        camera.setIcon(from: .fontAwesome, code: "camera", textColor: .black, backgroundColor: .clear, size: nil)

        let inputText = input.rx.controlEvent(.editingChanged)
            .map { self.input.text }
            .filter {($0 ?? "").count > 0}

        viewModel = RubyWriterViewModel(inputText: inputText,
                                        outputText: output.rx.text,
                                        hiraganaSwitch: toHiraganaSwitch.rx,
                                        katakanaSwitch: toKatakanaSwitch.rx)
    }

    @IBAction func didTouchCamera(_ sender: Any) {
        let alert = UIAlertController(title: "input text from camera", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            self.openCamera()
        }))

        alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

    func openCamera() {
        if !UIImagePickerController.isSourceTypeAvailable(.camera) {
            return
        }

        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = .camera
        //        imagePickerController.allowsEditing = true
        self.present(imagePickerController, animated: true, completion: nil)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        print("did finish")
    }
}
