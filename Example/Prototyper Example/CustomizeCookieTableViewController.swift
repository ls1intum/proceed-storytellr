//
//  CustomizeCookieTableViewController.swift
//  
//
//  Created by Lara Marie Reimer on 18.07.17.
//

import UIKit
import Prototyper

class CustomizeCookieTableViewController: UITableViewController {

    @IBOutlet weak var doughDetailLabel: UILabel!
    @IBOutlet weak var chocolateDetailLabel: UILabel!
    @IBOutlet weak var crunchinessDetailLabel: UILabel!
    @IBOutlet weak var timeDetailLabel: UILabel!
    @IBOutlet weak var paymentDetailLabel: UILabel!
    @IBOutlet weak var orderCookieButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        StoryTellrController.sharedInstance.currentScenarioStepNumber = 2
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        StoryTellrController.sharedInstance.resetCurrentStep()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let detailsVC = segue.destination as? CookieDetailsTableViewController {
            detailsVC.delegate = self
            
            if segue.identifier == "doughSegue"{
                detailsVC.detailType = CookieDetailTypes.dough
            } else if segue.identifier == "chocolateSegue"{
                detailsVC.detailType = CookieDetailTypes.chocolate
            } else if segue.identifier == "crunchinessSegue"{
                detailsVC.detailType = CookieDetailTypes.crunchiness
            } else if segue.identifier == "timeSegue"{
                detailsVC.detailType = CookieDetailTypes.time
            } else if segue.identifier == "paymentSegue"{
                detailsVC.detailType = CookieDetailTypes.payment
            }
        } else {
            if let doneVC = segue.destination as? OrderDoneViewController {
                doneVC.delegate = self
            }
        }
    }
    
    func checkCookieValues() {
        var shouldEnableOrderButton = true
        
        if let doughText = doughDetailLabel.text {
            if doughText == "Select your dough" {
                shouldEnableOrderButton = false
                return
            }
        }
        
        if let chocolateText = chocolateDetailLabel.text {
            if chocolateText == "Select your chocolate" {
                shouldEnableOrderButton = false
                return
            }
        }
        
        if let crunchinessText = crunchinessDetailLabel.text {
            if crunchinessText == "Select the crunchiness" {
                shouldEnableOrderButton = false
                return
            }
        }
        
        if let timeText = timeDetailLabel.text {
            if timeText == "Select the time" {
                shouldEnableOrderButton = false
                return
            }
        }
        
        if let paymentText = paymentDetailLabel.text {
            if paymentText == "Select your payment" {
                shouldEnableOrderButton = false
                return
            }
        }
        
        if shouldEnableOrderButton {
            orderCookieButton.isUserInteractionEnabled = true
            orderCookieButton.isEnabled = true
        }
    }
}

extension CustomizeCookieTableViewController: CookieDetailsTableViewControllerDelegate {
    func didSelectCell(withString: String, forType: CookieDetailTypes) {
        switch forType {
        case CookieDetailTypes.dough:
            doughDetailLabel.text = withString
            break
        case CookieDetailTypes.chocolate:
            chocolateDetailLabel.text = withString
            break
        case CookieDetailTypes.crunchiness:
            crunchinessDetailLabel.text = withString
            break
        case CookieDetailTypes.time:
            timeDetailLabel.text = withString
            break
        case CookieDetailTypes.payment:
            paymentDetailLabel.text = withString
            break
        }
        checkCookieValues()
    }
}

extension CustomizeCookieTableViewController: OrderDoneViewControllerDelegate {
    func didPressOrderDoneButton() {
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
}
