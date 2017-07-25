//
//  ScenarioInfoQuestionView.swift
//  StoryTellr
//
//  Created by Lara Marie Reimer on 27.05.17.
//  Copyright © 2017 Lara Marie Reimer. All rights reserved.
//

import UIKit

class ScenarioInfoQuestionView: ScenarioInfoView {
    // MARK: - Initialization
    convenience init() {
        self.init(scenarioStep: nil)
    }
    
    init(scenarioStep: ScenarioStep?) {
        super.init(frame: CGRect.zero)
        
        self.currentStep = scenarioStep
        self.questions = scenarioStep?.questions
        
        if let stepQuestions = self.questions {
            var questionsAnswered = true
            for question in stepQuestions {
                if question.answer.isEmpty {
                    questionsAnswered = false
                } else {
                    currentIndex += 1
                }
            }
            
            if !questionsAnswered {
                titleLabel.text = stepQuestions[currentIndex].questionDescription
                bottomView = feedbackBottomView
            } else {
                titleLabel.text = "There are no questions right now."
                bottomView = defaultBottomView
            }
            
        } else {
            titleLabel.text = "There are no questions right now."
            bottomView = defaultBottomView
        }
        
        self.setConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Autolayout
    
    func setConstraints() {
        backgroundView.addSubview(freeFeedbackButtonView)
        backgroundView.addSubview(helpButtonView)
        backgroundView.addSubview(bottomView)
        
        let viewsDictionary = ["help": helpButtonView, "freeFeedback": freeFeedbackButtonView, "title": titleLabel, "bottom": bottomView] as [String : Any]
        
        // position constraints
        let feedbackConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|[freeFeedback]",options: NSLayoutFormatOptions(rawValue: 0),metrics: nil, views: viewsDictionary)
        let helpConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:[help]|",options: NSLayoutFormatOptions(rawValue: 0),metrics: nil, views: viewsDictionary)
        let titleConstraint = NSLayoutConstraint.constraints(withVisualFormat: "H:|-20-[title]-20-|",options: NSLayoutFormatOptions(rawValue: 0),metrics: nil, views: viewsDictionary)
        let vConstraints = NSLayoutConstraint.constraints(withVisualFormat: "V:|-[help]-40@999-[title]-40@999-[bottom]-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewsDictionary)
        let vConstraintHelp = NSLayoutConstraint.constraints(withVisualFormat: "V:|-[freeFeedback]", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewsDictionary)
        
        let centerButtonX = NSLayoutConstraint(item: self.bottomView, attribute:.centerX, relatedBy:.equal, toItem: self.backgroundView, attribute:.centerX, multiplier: 1.0, constant: 0.0)
        
        backgroundView.addConstraint(centerButtonX)
        backgroundView.addConstraints(feedbackConstraints)
        backgroundView.addConstraints(helpConstraints)
        backgroundView.addConstraints(titleConstraint)
        backgroundView.addConstraints(vConstraints)
        backgroundView.addConstraints(vConstraintHelp)
    }
    
    // MARK: - Getters
    
    var freeFeedbackButtonView : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isUserInteractionEnabled = true
        
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "feedback", in: Bundle(for: LoginViewController.self), compatibleWith: nil), for: .normal)
        button.addTarget(self, action: #selector(didTapFeedbackButton), for: .touchUpInside)
        
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Give\nFeedback"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 9.0)
        label.textColor = PrototypeUI.ButtonColor
        label.backgroundColor = UIColor.clear
        label.numberOfLines = 0
        
        view.addSubview(button)
        view.addSubview(label)
        
        let viewsDictionary = ["button": button, "label": label] as [String : Any]
        
        //position constraints
        let hConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|-15-[button(30)]-15-|",options: NSLayoutFormatOptions(rawValue: 0),metrics: nil, views: viewsDictionary)
        let hConstraints2 = NSLayoutConstraint.constraints(withVisualFormat: "H:|-4-[label]-4-|",options: NSLayoutFormatOptions(rawValue: 0),metrics: nil, views: viewsDictionary)
        let vConstraintsLeft = NSLayoutConstraint.constraints(withVisualFormat: "V:|[button(30)]-2-[label]|",options: NSLayoutFormatOptions(rawValue: 0),metrics: nil, views: viewsDictionary)
        
        view.addConstraints(hConstraints)
        view.addConstraints(hConstraints2)
        view.addConstraints(vConstraintsLeft)
        
        return view
    }()
    
    var helpButtonView : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isUserInteractionEnabled = true
        
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "help", in: Bundle(for: LoginViewController.self), compatibleWith: nil), for: .normal)
        button.addTarget(self, action: #selector(didTapHelpButton), for: .touchUpInside)
        
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Help"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 9.0)
        label.textColor = PrototypeUI.ButtonColor
        label.backgroundColor = UIColor.clear
        
        view.addSubview(button)
        view.addSubview(label)
        
        let viewsDictionary = ["button": button, "label": label] as [String : Any]
        
        //position constraints
        let hConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|-20-[button(30)]-20-|",options: NSLayoutFormatOptions(rawValue: 0),metrics: nil, views: viewsDictionary)
        let hConstraints2 = NSLayoutConstraint.constraints(withVisualFormat: "H:|-4-[label]-4-|",options: NSLayoutFormatOptions(rawValue: 0),metrics: nil, views: viewsDictionary)
        let vConstraintsLeft = NSLayoutConstraint.constraints(withVisualFormat: "V:|[button(30)]-2-[label]|",options: NSLayoutFormatOptions(rawValue: 0),metrics: nil, views: viewsDictionary)
        
        view.addConstraints(hConstraints)
        view.addConstraints(hConstraints2)
        view.addConstraints(vConstraintsLeft)
        
        return view
    }()
    
    var bottomView : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isUserInteractionEnabled = true
        
        return view
    }()
    
    var defaultBottomView : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isUserInteractionEnabled = true
        
        let shareButton = UIButton()
        shareButton.translatesAutoresizingMaskIntoConstraints = false
        shareButton.titleLabel?.font = UIFont.systemFont(ofSize: 15.0)
        shareButton.setImage(UIImage(named: "share", in: Bundle(for: LoginViewController.self), compatibleWith: nil), for: .normal)
        shareButton.setTitle("Share App", for: .normal)
        shareButton.setTitleColor(PrototypeUI.ButtonColor, for: .normal)
        shareButton.addTarget(self, action: #selector(didTapShare), for: .touchUpInside)
        
        let dismissButton = UIButton()
        dismissButton.translatesAutoresizingMaskIntoConstraints = false
        dismissButton.setImage(UIImage(named: "dismiss", in: Bundle(for: LoginViewController.self), compatibleWith: nil), for: .normal)
        dismissButton.titleLabel?.font = UIFont.systemFont(ofSize: 15.0)
        dismissButton.setTitle("Dismiss StoryTellr", for: .normal)
        dismissButton.setTitleColor(PrototypeUI.ButtonColor, for: .normal)
        dismissButton.addTarget(self, action: #selector(didTapDismissButton), for: .touchUpInside)
        
        view.addSubview(shareButton)
        view.addSubview(dismissButton)
        
        let viewsDictionary = ["share": shareButton, "dismiss": dismissButton] as [String : Any]
        
        //position constraints
        let hConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|-10-[share]-10-|",options: NSLayoutFormatOptions(rawValue: 0),metrics: nil, views: viewsDictionary)
        let hConstraints2 = NSLayoutConstraint.constraints(withVisualFormat: "H:|-10-[dismiss]-10-|",options: NSLayoutFormatOptions(rawValue: 0),metrics: nil, views: viewsDictionary)
        let vConstraintsLeft = NSLayoutConstraint.constraints(withVisualFormat: "V:|-[share]-[dismiss]-|",options: NSLayoutFormatOptions(rawValue: 0),metrics: nil, views: viewsDictionary)
        
        view.addConstraints(hConstraints)
        view.addConstraints(hConstraints2)
        view.addConstraints(vConstraintsLeft)
        
        return view
    }()
    
    // MARK: - Button Actions
    
    @objc func didTapFeedbackButton(sender: UIButton) {
        guard let delegate = self.delegate else { return }
        delegate.didPressFreeFeedbackButton(_: sender)
    }
    
    @objc func didTapHelpButton(sender: UIButton) {
        guard let delegate = self.delegate else { return }
        delegate.didPressHelpButton(_: sender)
    }
    
    @objc func didTapShare(sender: UIButton) {
        guard let delegate = self.delegate else { return }
        delegate.didPressShareButton(_: sender)
    }
    
    @objc func didTapDismissButton(sender: UIButton) {
        guard let delegate = self.delegate else { return }
        delegate.didPressDismissButton(_: sender)
    }
    
    @objc override func didTapYes(sender: UIButton) {
        guard let delegate = self.delegate, let questions = self.questions else { return }
        let answer = questions[currentIndex].questionDescription + "YES"
        delegate.didPressBottomButton(_: sender, withAnswer: answer, isLastFeedback: currentIndex >= questions.count - 1)
        
        questions[currentIndex].answer = answer
        currentIndex += 1
    }
    
    @objc override func didTapNo(sender: UIButton) {
        guard let delegate = self.delegate, let questions = self.questions else { return }
        let answer = questions[currentIndex].questionDescription + "NO"
        delegate.didPressBottomButton(_: sender, withAnswer: answer, isLastFeedback: currentIndex >= questions.count - 1)
        
        questions[currentIndex].answer = answer
        currentIndex += 1
    }
}
