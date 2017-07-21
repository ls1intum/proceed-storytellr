//
//  OrderDoneViewController.swift
//  Prototyper Example
//
//  Created by Lara Marie Reimer on 18.07.17.
//  Copyright © 2017 TUM LS1. All rights reserved.
//

import UIKit
import Prototyper

protocol OrderDoneViewControllerDelegate: class {
    func didPressOrderDoneButton()
}

class OrderDoneViewController: UIViewController {
    
    weak var delegate : OrderDoneViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        StoryTellrController.sharedInstance.currentScenarioStepNumber = 8
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        StoryTellrController.sharedInstance.resetCurrentStep()
    }
    
    @IBAction func didTapOkayButton(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
        
        if let delegate = delegate {
            delegate.didPressOrderDoneButton()
        }
    }
}
