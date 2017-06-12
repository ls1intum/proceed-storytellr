//
//  ViewController.swift
//  Prototyper Example
//
//  Created by Paul Schmiedmayer on 6/6/17.
//  Copyright © 2017 TUM LS1. All rights reserved.
//

import UIKit
import Prototyper

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        StoryTellrController.sharedInstance.currentIndex = 1
    }
}

