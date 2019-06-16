//
//  RubyWriterViewController.swift
//  RubyWriter
//
//  Created by 中川慶悟 on 2019/06/16.
//  Copyright © 2019 Keigo Nakagawa. All rights reserved.
//

import UIKit

class RubyWriterViewController: UIViewController {

    @IBOutlet weak var toHiraganaSwitch: UISwitch!
    @IBOutlet weak var toKatakanaSwitch: UISwitch!
    @IBOutlet weak var input: UITextField!
    @IBOutlet weak var output: UITextField!
   
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
