//
//  ScenarioInfoCompletedView.swift
//  StoryTellr
//
//  Created by Lara Marie Reimer on 28.05.17.
//  Copyright © 2017 Lara Marie Reimer. All rights reserved.
//

import UIKit

class ScenarioInfoCompletedView: ScenarioInfoView {
    
    // MARK: Initialization
    
    convenience init() {
        self.init(scenarioStep: nil)
    }
    
    init(scenarioStep: ScenarioStep?) {
        super.init(frame: CGRect.zero)
        
        titleLabel.text = "Congratulations!\nYou've completed this scenario.\nDid you like the implementation of it?"
        
        self.backgroundView.addSubview(feedbackBottomView)
        self.setConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setConstraints() {
        backgroundView.addSubview(completedView)
        
        let viewsDictionary = ["completed": completedView, "title": titleLabel, "bottom" : feedbackBottomView] as [String : Any]
        
        //position constraints
        let hConstraintCompleted = NSLayoutConstraint.constraints(withVisualFormat: "[completed(40)]", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewsDictionary)
        let vConstraintsCompleted = NSLayoutConstraint.constraints(withVisualFormat: "V:|-[completed(40)]-25@999-[title]-25@999-[bottom]-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewsDictionary)
        let titleConstraint = NSLayoutConstraint.constraints(withVisualFormat: "H:|-20-[title]-20-|",options: NSLayoutFormatOptions(rawValue: 0),metrics: nil, views: viewsDictionary)
        
        let centerCompletedX = NSLayoutConstraint(item: completedView, attribute:.centerX, relatedBy:.equal, toItem: backgroundView, attribute:.centerX, multiplier: 1.0, constant: 0.0)
        let centerBottomX = NSLayoutConstraint(item: feedbackBottomView, attribute:.centerX, relatedBy:.equal, toItem: self.backgroundView, attribute:.centerX, multiplier: 1.0, constant: 0.0)
        
        backgroundView.addConstraint(centerCompletedX)
        backgroundView.addConstraint(centerBottomX)
        backgroundView.addConstraints(hConstraintCompleted)
        backgroundView.addConstraints(vConstraintsCompleted)
        backgroundView.addConstraints(titleConstraint)
        
    }
    
    var completedView : UIImageView = {
        let view = UIImageView()
        view.backgroundColor = UIColor.clear
        view.image = UIImage(named: "check", in: Bundle(for: LoginViewController.self), compatibleWith: nil)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
}
