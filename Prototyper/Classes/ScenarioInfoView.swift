//
//  ScenarioInfoView.swift
//  StoryTellr
//
//  Created by Lara Marie Reimer on 27.05.17.
//  Copyright © 2017 Lara Marie Reimer. All rights reserved.
//

import UIKit

protocol ScenarioInfoViewDelegate : class {
    func didPressBottomButton(_: UIButton, withAnswer: String?, isLastFeedback: Bool?) -> Void
    func didPressFreeFeedbackButton(_: UIButton) -> Void
    func didPressHelpButton(_: UIButton) -> Void
    func didPressShareButton(_: UIButton) -> Void
    func didPressDismissButton(_: UIButton) -> Void
}

class ScenarioInfoView: UIView {
    
    // MARK: Properties
    
    var didSetupConstraints = false
    
    var currentStep : ScenarioStep?
    var questions : [ScenarioQuestion]?
    
    weak var delegate : ScenarioInfoViewDelegate?
    
    // MARK: Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = UIColor.withAlphaComponent(UIColor.black)(0.5)
        
        self.addSubview(backgroundView)
        self.addSubview(cancelButton)
        self.backgroundView.addSubview(titleLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Autolayout
    
    override func updateConstraints() {
        if(!didSetupConstraints) {
            // AutoLayout constraints
            didSetupConstraints = true
            
            //position constraints
            let viewsDictionary = ["background": backgroundView, "cancel": cancelButton] as [String : Any]
            
            let hConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|-40-[background]-40-|", options: NSLayoutFormatOptions(rawValue: 0),metrics: nil, views: viewsDictionary)
            let centerContentY = NSLayoutConstraint(item: backgroundView, attribute: .centerY, relatedBy:.equal, toItem: self, attribute: .centerY, multiplier: 1.0, constant: 1.0)
            let centerButtonX = NSLayoutConstraint(item: cancelButton, attribute: .centerX, relatedBy:.equal, toItem: backgroundView, attribute: .right, multiplier: 1.0, constant: 1.0)
            let centerButtonY = NSLayoutConstraint(item: cancelButton, attribute: .centerY, relatedBy:.equal, toItem: backgroundView, attribute: .top, multiplier: 1.0, constant: 1.0)
            
            addConstraints(hConstraints)
            addConstraint(centerContentY)
            addConstraint(centerButtonX)
            addConstraint(centerButtonY)
        }
        super.updateConstraints()
    }
    
    // MARK: - Getters
    
    var currentIndex : Int = 0 {
        didSet {
            if let stepQuestions = questions {
                if currentIndex <= stepQuestions.count - 1 {
                    titleLabel.text = stepQuestions[currentIndex].questionDescription
                }
            } else {
                titleLabel.text = "There are no questions right now."
            }
        }
    }
    
    var backgroundView : UIView = {
        let background = UIView()
        background.backgroundColor = UIColor.white
        background.layer.cornerRadius = 15.0
        background.translatesAutoresizingMaskIntoConstraints = false
        return background
    }()
    
    var titleLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 17.0)
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    var cancelButton : UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "delete_icon", in: Bundle(for: LoginViewController.self), compatibleWith: nil), for: .normal)
        button.addTarget(self, action: #selector(didTapCancelButton), for: .touchUpInside)
        return button
    }()
    
    var feedbackBottomView : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isUserInteractionEnabled = true
        
        let leftButton = UIButton()
        leftButton.translatesAutoresizingMaskIntoConstraints = false
        leftButton.setImage(UIImage(named: "check", in: Bundle(for: LoginViewController.self), compatibleWith: nil), for: .normal)
        leftButton.addTarget(self, action: #selector(didTapYes), for: .touchUpInside)
        
        let rightButton = UIButton()
        rightButton.translatesAutoresizingMaskIntoConstraints = false
        rightButton.setImage(UIImage(named: "cancel", in: Bundle(for: LoginViewController.self), compatibleWith: nil), for: .normal)
        rightButton.addTarget(self, action: #selector(didTapNo), for: .touchUpInside)
        
        view.addSubview(leftButton)
        view.addSubview(rightButton)
        
        let viewsDictionary = ["left": leftButton, "right": rightButton] as [String : Any]
        
        //position constraints
        let hConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|-10-[left(40)]-(>=90@999)-[right(40)]-10-|",options: NSLayoutFormatOptions(rawValue: 0),metrics: nil, views: viewsDictionary)
        let vConstraintsLeft = NSLayoutConstraint.constraints(withVisualFormat: "V:|[left(40)]-10-|",options: NSLayoutFormatOptions(rawValue: 0),metrics: nil, views: viewsDictionary)
        let vConstraintsRight = NSLayoutConstraint.constraints(withVisualFormat: "V:|[right(40)]-10-|",options: NSLayoutFormatOptions(rawValue: 0),metrics: nil, views: viewsDictionary)
        
        view.addConstraints(hConstraints)
        view.addConstraints(vConstraintsLeft)
        view.addConstraints(vConstraintsRight)
        
        return view
    }()
    
    // MARK : - Button Actions
    
    @objc func didTapCancelButton(sender: UIButton) {
        guard let delegate = self.delegate else { return }
        delegate.didPressDismissButton(sender)
    }    
    
    @objc func didTapYes(sender: UIButton) {
        guard let delegate = self.delegate else { return }
        let answer = "Did you like the implementation of this scenario? - YES"
        delegate.didPressBottomButton(_: sender, withAnswer: answer, isLastFeedback: false)
    }
    
    @objc func didTapNo(sender: UIButton) {
        guard let delegate = self.delegate else { return }
        let answer = "Did you like the implementation of this scenario? - NO"
        delegate.didPressBottomButton(_: sender, withAnswer: answer, isLastFeedback: false)
    }
}
