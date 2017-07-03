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
                if !question.isAnswered {
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
        backgroundView.addSubview(freeFeedbackButton)
        backgroundView.addSubview(helpButton)
        backgroundView.addSubview(bottomView)
        
        let viewsDictionary = ["help": helpButton, "freeFeedback": freeFeedbackButton, "title": titleLabel, "bottom": bottomView] as [String : Any]
        
        // position constraints
        let feedbackConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|-10-[freeFeedback(40)]",options: NSLayoutFormatOptions(rawValue: 0),metrics: nil, views: viewsDictionary)
        let helpConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:[help(40)]-10-|",options: NSLayoutFormatOptions(rawValue: 0),metrics: nil, views: viewsDictionary)
        let titleConstraint = NSLayoutConstraint.constraints(withVisualFormat: "H:|-20-[title]-20-|",options: NSLayoutFormatOptions(rawValue: 0),metrics: nil, views: viewsDictionary)
        let vConstraints = NSLayoutConstraint.constraints(withVisualFormat: "V:|-[freeFeedback(40)]-25@999-[title]-25@999-[bottom]-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewsDictionary)
        let vConstraintHelp = NSLayoutConstraint.constraints(withVisualFormat: "V:|-[help(40)]", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewsDictionary)
        
        let centerTitleY = NSLayoutConstraint(item: self.titleLabel, attribute:.centerY, relatedBy:.equal, toItem: self.backgroundView, attribute:.centerY, multiplier: 1.0, constant: 0.0)
        let centerButtonX = NSLayoutConstraint(item: self.bottomView, attribute:.centerX, relatedBy:.equal, toItem: self.backgroundView, attribute:.centerX, multiplier: 1.0, constant: 0.0)
        
        backgroundView.addConstraint(centerButtonX)
        backgroundView.addConstraint(centerTitleY)
        backgroundView.addConstraints(feedbackConstraints)
        backgroundView.addConstraints(helpConstraints)
        backgroundView.addConstraints(titleConstraint)
        backgroundView.addConstraints(vConstraints)
        backgroundView.addConstraints(vConstraintHelp)
    }
    
    // MARK: - Getters
    
    var freeFeedbackButton : UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "Feedback-96", in: Bundle(for: LoginViewController.self), compatibleWith: nil), for: .normal)
        button.addTarget(self, action: #selector(didTapFeedbackButton), for: .touchUpInside)
        return button
    }()
    
    var helpButton : UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "Help-100", in: Bundle(for: LoginViewController.self), compatibleWith: nil), for: .normal)
        button.addTarget(self, action: #selector(didTapHelpButton), for: .touchUpInside)
        return button
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
        shareButton.setTitle("Share App", for: .normal)
        shareButton.setTitleColor(UIColor.init(colorLiteralRed: 3.0/255.0, green: 101.0/255.0, blue: 192.0/255.0, alpha: 1.0), for: .normal)
        shareButton.addTarget(self, action: #selector(didTapShare), for: .touchUpInside)
        
        let dismissButton = UIButton()
        dismissButton.translatesAutoresizingMaskIntoConstraints = false
        dismissButton.titleLabel?.font = UIFont.systemFont(ofSize: 15.0)
        dismissButton.setTitle("Dismiss StoryTellr Button", for: .normal)
        dismissButton.setTitleColor(UIColor.init(colorLiteralRed: 3.0/255.0, green: 101.0/255.0, blue: 192.0/255.0, alpha: 1.0), for: .normal)
        dismissButton.addTarget(self, action: #selector(didTapDismissButton), for: .touchUpInside)
        
        view.addSubview(shareButton)
        view.addSubview(dismissButton)
        
        let viewsDictionary = ["share": shareButton, "dismiss": dismissButton] as [String : Any]
        
        //position constraints
        let hConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|-10-[share]-10-|",options: NSLayoutFormatOptions(rawValue: 0),metrics: nil, views: viewsDictionary)
        let hConstraints2 = NSLayoutConstraint.constraints(withVisualFormat: "H:|-10-[dismiss]-10-|",options: NSLayoutFormatOptions(rawValue: 0),metrics: nil, views: viewsDictionary)
        let vConstraintsLeft = NSLayoutConstraint.constraints(withVisualFormat: "V:|[share]-12-[dismiss]-|",options: NSLayoutFormatOptions(rawValue: 0),metrics: nil, views: viewsDictionary)
        
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
        
        questions[currentIndex].isAnswered = true
        currentIndex += 1
    }
    
    @objc override func didTapNo(sender: UIButton) {
        guard let delegate = self.delegate, let questions = self.questions else { return }
        let answer = questions[currentIndex].questionDescription + "NO"
        delegate.didPressBottomButton(_: sender, withAnswer: answer, isLastFeedback: currentIndex >= questions.count - 1)
        
        questions[currentIndex].isAnswered = true
        currentIndex += 1
    }
}
