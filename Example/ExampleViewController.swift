//
//  ExampleViewController.swift
//  Example
//
//  Created by Yonas Kolb on 4/6/18.
//  Copyright © 2018 Stylist. All rights reserved.
//

import Foundation
import UIKit
import Stylist

class ExampleViewController: UIViewController {
    @IBOutlet weak var button: UIButton!

    @IBAction func buttonPressed(_ sender: Any) {
        button.style = buttonStyle.text
    }
    @IBOutlet weak var buttonStyle: UITextField!
    @IBAction func buttonStyleChanged(_ sender: UITextField) {
        button.style = sender.text
    }
    @IBAction func switchStyleChanged(_ sender: UITextField) {
        `switch`.style = sender.text
    }
    @IBOutlet weak var `switch`: UISwitch!
}
