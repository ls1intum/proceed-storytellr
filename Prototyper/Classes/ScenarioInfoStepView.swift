//
//  ScenarioInfoStepView.swift
//  StoryTellr
//
//  Created by Lara Marie Reimer on 27.05.17.
//  Copyright © 2017 Lara Marie Reimer. All rights reserved.
//

import UIKit

class ScenarioInfoStepView: ScenarioInfoView {
    
    // MARK: Initialization
    
    convenience init() {
        self.init(scenarioStep: nil)
    }
    
    init(scenarioStep: ScenarioStep?) {
        super.init(frame: CGRect.zero)
        
        self.currentStep = scenarioStep
        self.questions = nil
        
        if let step = currentStep {
            currentStepLabel.text = String(describing: step.stepNumber)
            titleLabel.text = step.stepDescription
        } else {
            currentStepLabel.text = "0"
            titleLabel.text = "There is no scenario step for this screen available"
        }
        
        self.setConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Autolayout
    
    func setConstraints() {
        backgroundView.addSubview(stepView)
        backgroundView.addSubview(bottomView)
        stepView.addSubview(currentStepLabel)
        
        let viewsDictionary = ["step": stepView, "stepLabel": currentStepLabel, "title": titleLabel, "bottom": bottomView] as [String : Any]
        
        //position constraints in background
        let titleConstraint = NSLayoutConstraint.constraints(withVisualFormat: "H:|-20-[title]-20-|",options: NSLayoutFormatOptions(rawValue: 0),metrics: nil, views: viewsDictionary)
        let vConstraints = NSLayoutConstraint.constraints(withVisualFormat: "V:|-[step(50)]-40@999-[title]-40@999-[bottom]-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewsDictionary)
        let vConstraintsStep = NSLayoutConstraint.constraints(withVisualFormat: "[step(50)]", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewsDictionary)
        
        let centerStepX = NSLayoutConstraint(item: self.stepView, attribute:.centerX, relatedBy:.equal, toItem: self.backgroundView, attribute:.centerX, multiplier: 1.0, constant: 0.0)
        let centerButtonX = NSLayoutConstraint(item: self.bottomView, attribute:.centerX, relatedBy:.equal, toItem: self.backgroundView, attribute:.centerX, multiplier: 1.0, constant: 0.0)
        let centerTitleX = NSLayoutConstraint(item: self.titleLabel, attribute:.centerX, relatedBy:.equal, toItem: self.backgroundView, attribute:.centerX, multiplier: 1.0, constant: 0.0)
        
        backgroundView.addConstraint(centerStepX)
        backgroundView.addConstraint(centerButtonX)
        backgroundView.addConstraint(centerTitleX)
        backgroundView.addConstraints(titleConstraint)
        backgroundView.addConstraints(vConstraints)
        backgroundView.addConstraints(vConstraintsStep)
        
        //position constraints in stepView
        let centerX = NSLayoutConstraint(item: currentStepLabel, attribute:.centerX, relatedBy:.equal, toItem: stepView, attribute:.centerX, multiplier: 1.0, constant: 0.0)
        let centerY = NSLayoutConstraint(item: currentStepLabel, attribute:.centerY, relatedBy:.equal, toItem: stepView, attribute:.centerY, multiplier: 1.0, constant: 0.0)
        
        stepView.addConstraint(centerX)
        stepView.addConstraint(centerY)
    }
    
    // MARK: Getters
    
    var stepView : UIView = {
        let view = UIView()
        view.backgroundColor = PrototypeUI.ButtonColor
        view.layer.cornerRadius = 25.0
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    var currentStepLabel : UILabel = {
        let stepLabel = UILabel()
        stepLabel.translatesAutoresizingMaskIntoConstraints = false
        stepLabel.font = UIFont.boldSystemFont(ofSize: 30.0)
        stepLabel.textColor = UIColor.white
        stepLabel.text = "0"
        
        return stepLabel
    }()
    
    var bottomView : UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = PrototypeUI.ButtonColor
        button.layer.cornerRadius = 15.0
        button.setImage(UIImage(named: "check"), for: .normal)
        button.setTitle("OKAY", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15.0)
        button.contentEdgeInsets = UIEdgeInsetsMake(10.0, 10.0, 10.0, 10.0)
        button.addTarget(self, action: #selector(didTapOkay), for: .touchUpInside)
        return button
    }()
    
    // MARK: Actions
    
    @objc func didTapOkay(sender: UIButton) {
        guard let delegate = self.delegate else { return }
        delegate.didPressBottomButton(_: sender, withAnswer: nil, isLastFeedback: nil)
        print("Tap received")
    }
}
