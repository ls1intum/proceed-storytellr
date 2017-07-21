//
//  CookieDetailsTableViewController.swift
//  Prototyper Example
//
//  Created by Lara Marie Reimer on 18.07.17.
//  Copyright © 2017 TUM LS1. All rights reserved.
//

import UIKit
import Prototyper

enum CookieDetailTypes : Int {
    case dough = 0
    case chocolate
    case crunchiness
    case time
    case payment
}

protocol CookieDetailsTableViewControllerDelegate : class {
    func didSelectCell(withString: String, forType: CookieDetailTypes)
}

class CookieDetailsTableViewController: UITableViewController {
    
    var detailType: CookieDetailTypes?
    
    weak var delegate: CookieDetailsTableViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        StoryTellrController.sharedInstance.currentScenarioStepNumber = getStepNumber()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        StoryTellrController.sharedInstance.resetCurrentStep()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let delegate = delegate, let type = detailType {
            delegate.didSelectCell(withString: getCellContent(forRow: indexPath.row), forType: type)
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    func getCellContent(forRow: Int) -> String {
        guard let type = detailType else { return "" }
        switch type {
        case CookieDetailTypes.dough:
            switch forRow {
            case 0: return "Chocolate Dough"
            case 1: return "Cookie Dough"
            case 2: return "Cinnamon Dough"
            default: return ""
            }
        case CookieDetailTypes.chocolate:
            switch forRow {
            case 0: return "Dark Chocolate"
            case 1: return "White Chocolate"
            case 2: return "Triple Chocolate"
            default: return ""
            }
        case CookieDetailTypes.crunchiness:
            switch forRow {
            case 0: return "Soft"
            case 1: return "Medium"
            case 2: return "Crunchy"
            default: return ""
            }
        case CookieDetailTypes.time:
            switch forRow {
            case 0: return "Now"
            case 1: return "15 min"
            case 2: return "30 min"
            case 3: return "45 min"
            case 4: return "1h"
            default: return ""
            }
        case CookieDetailTypes.payment:
            switch forRow {
            case 0: return "Visa"
            case 1: return "Mastercard"
            case 2: return "Paypal"
            default: return ""
            }
        }
    }
    
    func getStepNumber() -> Int {
        guard let type = detailType else { return 3 }
        switch type {
        case CookieDetailTypes.dough:
            return 3
        case CookieDetailTypes.chocolate:
            return 4
        case CookieDetailTypes.crunchiness:
            return 5
        case CookieDetailTypes.time:
            return 6
        case CookieDetailTypes.payment:
            return 7
        }
    }
}
