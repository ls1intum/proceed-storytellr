//
//  ScenarioInfoViewController.swift
//  StoryTellr
//
//  Created by Lara Marie Reimer on 27.05.17.
//  Copyright © 2017 Lara Marie Reimer. All rights reserved.
//

// Data Types for handling the layout of the view

import UIKit

protocol ScenarioInfoViewControllerDelegate : class {
    func didPressFreeFeedback(_ : UIButton) -> Void
    func didPressShare(_ : UIButton) -> Void
    func didPressDismissButton(_ : UIButton) -> Void
    func didPressHelpButton(_ : UIButton) -> Void
}

class ScenarioInfoViewController: UIViewController, ScenarioInfoViewDelegate {
    
    weak var delegate : ScenarioInfoViewControllerDelegate?
    
    // MARK: - Properties
    
    var scenarioStep : ScenarioStep?
    var isLastStep = false
    
    // MARK: - Initialization
    
    convenience init() {
        self.init(dataType: .Undefined, isLastStep: false)
    }
    
    init(dataType: InfoDataType, isLastStep: Bool) {
        self.isLastStep = isLastStep
        
        defer {
            if let step = StoryTellrController.sharedInstance.currentStep {
                self.scenarioStep = step
            }
            self.dataType = dataType
        }
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK:
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scenarioInfoView.delegate = self
        
        view.addSubview(scenarioInfoView)
        
        let viewsDictionary = ["info": scenarioInfoView] as [String : Any]
        
        //position constraints
        let contentConstraint = NSLayoutConstraint.constraints(withVisualFormat: "|[info]|", options: NSLayoutFormatOptions(rawValue: 0),metrics: nil, views: viewsDictionary)
        let contentVConstraint = NSLayoutConstraint.constraints(withVisualFormat: "V:|[info]|", options: NSLayoutFormatOptions(rawValue: 0),metrics: nil, views: viewsDictionary)
        
        view.addConstraints(contentConstraint)
        view.addConstraints(contentVConstraint)
    }
    
    // MARK: - Getters
    
    var dataType : InfoDataType? {
        didSet {
            if dataType == .ScenarioStep {
                if let step = scenarioStep {
                    if isLastStep {
                        scenarioInfoView = ScenarioInfoCompletedView.init(scenarioStep: step)
                    } else {
                        scenarioInfoView = ScenarioInfoStepView.init(scenarioStep: scenarioStep)
                    }
                } else {
                    scenarioInfoView = ScenarioInfoStepView.init(scenarioStep: scenarioStep)
                }
            } else {
                scenarioInfoView = ScenarioInfoQuestionView.init(scenarioStep: scenarioStep)
            }
            
            scenarioInfoView.translatesAutoresizingMaskIntoConstraints = false
            scenarioInfoView.delegate = self
        }
    }
    
    var scenarioInfoView : ScenarioInfoView = {
        let view = ScenarioInfoView(frame: CGRect.zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // MARK: - ScenarioInfoViewDelegate
    
    func didPressBottomButton(_: UIButton, withAnswer: String?, isLastFeedback: Bool?) {
        if let answer = withAnswer, let lastFeeback = isLastFeedback {
            // Received a valid answer.
            let name = String(describing: UserDefaults.standard.object(forKey: UserDefaultKeys.Username))
            APIHandler.sharedAPIHandler.sendGeneralFeedback(description: answer, name: name, success: {
                PrototypeController.sharedInstance.decrementNotificationNumber(by: 1)
            }, failure: { (error) in
                // add error handling
            })
            
           if lastFeeback || (isLastStep && dataType == .ScenarioStep) {
                // Dismiss the VC.
                self.dismiss(animated: true, completion: nil)
            }
        } else {
            // Dismiss the VC.
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    func didPressHelpButton(_ button: UIButton) {
        guard let delegate = self.delegate else { return }
        self.dismiss(animated: true) {
            delegate.didPressHelpButton(button)
        }
    }
    
    func didPressFreeFeedbackButton(_ button: UIButton) {
        guard let delegate = self.delegate else { return }
        self.dismiss(animated: true) { 
            delegate.didPressFreeFeedback(button)
        }
    }
    
    func didPressShareButton(_ button: UIButton) {
        guard let delegate = self.delegate else { return }
        self.dismiss(animated: true) {
            delegate.didPressShare(button)
        }
    }
    
    func didPressDismissButton(_ button: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}
