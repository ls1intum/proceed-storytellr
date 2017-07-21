//
//  FeedbackBubble.swift
//  Pods
//
//  Created by Stefan Kofler on 17.10.16.
//
//

import Foundation

class FeedbackBubble: UIView {
    
    private static var size = CGSize(width: 70, height: 70)
    
    init(target: Any, action: Selector) {
        super.init(frame: CGRect(x: -FeedbackBubble.size.width/2, y: UIScreen.main.bounds.size.height/2, width: FeedbackBubble.size.width, height: FeedbackBubble.size.height))
        
        let feedbackButton = UIButton(type: .custom)
        feedbackButton.setImage(UIImage(named: "feedback_icon", in: Bundle(for: LoginViewController.self), compatibleWith: nil), for: .normal)
        feedbackButton.frame = CGRect(x: 0, y: 0, width: FeedbackBubble.size.width, height: FeedbackBubble.size.height)
        feedbackButton.addTarget(target, action: action, for: .touchUpInside)
        self.addSubview(feedbackButton)
        
        self.addSubview(notificationBubble)
        self.notificationBubble.addSubview(notificationLabel)
        
        //position constraints
        let viewsDictionary = ["background": self.notificationBubble, "label": notificationLabel] as [String : Any]
        
        let hConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|-2-[label]-2-|", options: NSLayoutFormatOptions(rawValue: 0),metrics: nil, views: viewsDictionary)
        let vConstraints = NSLayoutConstraint.constraints(withVisualFormat: "V:|-2-[label]-2-|", options: NSLayoutFormatOptions(rawValue: 0),metrics: nil, views: viewsDictionary)
        let hBubbleConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:[background(25)]-(-8)-|", options: NSLayoutFormatOptions(rawValue: 0),metrics: nil, views: viewsDictionary)
        let vBubbleConstraints = NSLayoutConstraint.constraints(withVisualFormat: "V:|-(-5)-[background(25)]", options: NSLayoutFormatOptions(rawValue: 0),metrics: nil, views: viewsDictionary)
        
        self.notificationBubble.addConstraints(hConstraints)
        self.notificationBubble.addConstraints(vConstraints)
        self.addConstraints(hBubbleConstraints)
        self.addConstraints(vBubbleConstraints)
        
        let panRecognizer = UIPanGestureRecognizer(target:self, action: #selector(detectPan(recognizer:)))
        self.gestureRecognizers = [panRecognizer]
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate var notificationBubble : UIView = {
        let notificationBubble = UIView()
        notificationBubble.translatesAutoresizingMaskIntoConstraints = false
        notificationBubble.backgroundColor = UIColor.red
        notificationBubble.layer.cornerRadius = 12.5
        notificationBubble.alpha = 0
        
        return notificationBubble
    }()
    
    fileprivate var notificationLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.white
        label.font = UIFont.boldSystemFont(ofSize: 16.0)
        label.textAlignment = .center
        label.text = "0"
        
        return label
    }()
    
    open var notificationNumber = 0 {
        didSet {
            if notificationNumber > 0 {
                notificationBubble.alpha = 1
                notificationLabel.text = String(notificationNumber)
            } else {
                notificationBubble.alpha = 0
            }
        }
    }
    
    @objc func detectPan(recognizer: UIPanGestureRecognizer) {
        self.center = recognizer.location(in: self.superview)
        let superViewWidth = self.superview?.bounds.size.width ?? 0
        let superViewHeight = self.superview?.bounds.size.height ?? 0
        
        if recognizer.state == .ended {
            let endPositionX: CGFloat
            if self.center.x <= superViewWidth/2 {
                endPositionX = -FeedbackBubble.size.width/2
            } else {
                endPositionX = superViewWidth-FeedbackBubble.size.width/2
            }
            
            let detectedVelocity = recognizer.velocity(in: self.superview).y
            let velocity: CGFloat = abs(detectedVelocity) > 100 ? (detectedVelocity > 0 ? 50 : -50) : 0
            let endPositionY = min(max(0, self.frame.origin.y + velocity), superViewHeight-FeedbackBubble.size.height)
            
            UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: { 
                self.frame.origin.x = endPositionX
                self.frame.origin.y = endPositionY
            }, completion: nil)
        }
    }
    
}
