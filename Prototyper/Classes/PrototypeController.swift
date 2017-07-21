//
//  PrototypeController.swift
//  PrototypeFrameWork
//
//  Created by Stefan Kofler on 28.05.16.
//  Copyright © 2016 Stefan Kofler. All rights reserved.
//

import Foundation
import KeychainSwift

open class PrototypeController: NSObject, ScenarioInfoViewControllerDelegate {
    open static let sharedInstance = PrototypeController()
    
    fileprivate var feedbackBubble: FeedbackBubble!
    
    var isFeedbackButtonHidden: Bool = false {
        didSet {
            if isFeedbackButtonHidden {
                feedbackBubble?.isHidden = true
            } else {
                feedbackBubble?.isHidden = false
            }
        }
    }
    
    open func showFeedbackButton(_ shouldShowFeedbackButton: Bool) {
        if shouldShowFeedbackButton {
            isFeedbackButtonHidden = false
            addFeedbackButton()
            tryToFetchReleaseInfos()
        } else {
            isFeedbackButtonHidden = true
        }
    }
    
    open func setNotificationNumber(to: Int) {
        feedbackBubble.notificationNumber = to
    }
    
    open func incrementNotificationNumber(by: Int) {
        feedbackBubble.notificationNumber += by
    }
    
    open func decrementNotificationNumber(by: Int) {
        feedbackBubble.notificationNumber -= by
    }
    
    // MARK: Feedback
    
    @objc func feedbackBubbleTouched() {
        guard let rootViewController = Utils.getTopViewController() else { return }
        
        let infoViewController = ScenarioInfoViewController(dataType: .Question, isLastStep: false)
        infoViewController.delegate = self
        
        infoViewController.modalPresentationStyle = .overFullScreen
        rootViewController.present(infoViewController, animated: true, completion: nil)
    }
    
    func showFeedbackView() {
        guard let rootViewController = Utils.getTopViewController() else { return }
        
        let feedbackViewController = FeedbackViewController()
        feedbackViewController.wasFeedbackButtonHidden = PrototypeController.sharedInstance.isFeedbackButtonHidden
        PrototypeController.sharedInstance.isFeedbackButtonHidden = true
        
        let screenshot = UIApplication.shared.keyWindow?.snaphot()
        feedbackViewController.screenshot = screenshot
        
        let navigationController = UINavigationController(rootViewController: feedbackViewController)
        rootViewController.present(navigationController, animated: true, completion: nil)
    }
    
    private func addFeedbackButton() {
        let keyWindow = UIApplication.shared.keyWindow ?? UIApplication.shared.windows.first
        feedbackBubble = feedbackBubble == nil ? FeedbackBubble(target: self, action: #selector(feedbackBubbleTouched)) : feedbackBubble
        feedbackBubble.layer.zPosition = 100
        keyWindow?.addSubview(feedbackBubble)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            keyWindow?.addSubview(self.feedbackBubble)
        }
    }
    
    private func hideFeedbackButton() {
        UIView.animate(withDuration: 0.3, animations: {
            self.feedbackBubble?.alpha = 0.0
        }) { _ in
            self.showFeedbackButton(false)
            self.feedbackBubble?.alpha = 1.0
            
            self.showInfoAlertAfterHiding()
        }
    }
    
    private func shareApp() {
        guard let rootViewController = Utils.getTopViewController() else { return }
        
        let shareViewController = ShareViewController()
        
        let navigationController = UINavigationController(rootViewController: shareViewController)
        rootViewController.present(navigationController, animated: true, completion: nil)
    }
    
    private func showInfoAlertAfterHiding() {
        guard let rootViewController = Utils.getTopViewController() else { return }
        
        let alertController = UIAlertController(title: Texts.FeedbackHideAlertSheet.Title, message: nil, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: Texts.FeedbackHideAlertSheet.OK, style: .default, handler: nil))
        rootViewController.present(alertController, animated: true, completion: nil)
    }
    
    // MARK: Helpers
    
    private func tryToFetchReleaseInfos() {
        APIHandler.sharedAPIHandler.fetchReleaseInformation(success: { (appId, releaseId) in
            UserDefaults.standard.set(appId, forKey: UserDefaultKeys.AppId)
            UserDefaults.standard.set(releaseId, forKey: UserDefaultKeys.ReleaseId)
        }) { error in
            print("No release information found on Prototyper.")
        }
    }
    
    private func tryToLogin() {
        let keychain = KeychainSwift()
        let oldUsername = keychain.get(LoginViewController.UsernameKey)
        let oldPassword = keychain.get(LoginViewController.PasswordKey)
        
        if let oldUsername = oldUsername, let oldPassword = oldPassword {
            APIHandler.sharedAPIHandler.login(oldUsername, password: oldPassword, success: {}, failure: { _ in })
        }
    }
    
    // MARK: - ScenarioInfoViewControllerDelegate
    
    func didPressSaveFeedbackButton(_: UIButton) {
        StoryTellrController.sharedInstance.numberOfUnansweredQuestionsInScenario -= 1
        
        // Save scenario.
        ScenarioDataHandler.sharedInstance.saveToJSON()
        
        // Update the notification count
        decrementNotificationNumber(by: 1)
    }
    
    func didPressFreeFeedback(_ : UIButton) {
        self.showFeedbackView()
    }
    
    func didPressShare(_ : UIButton) {
        self.shareApp()
    }
    
    func didPressDismissButton(_ : UIButton) {
        self.hideFeedbackButton()
        StoryTellrController.sharedInstance.shouldShowScenarioSteps = false
    }
    
    func didPressHelpButton(_: UIButton) {
        guard let rootViewController = Utils.getTopViewController() else { return }
        
        let infoViewController = ScenarioInfoViewController(dataType: .ScenarioStep, isLastStep: StoryTellrController.sharedInstance.isLastStep)
        infoViewController.delegate = self
        
        infoViewController.modalPresentationStyle = .overFullScreen
        rootViewController.present(infoViewController, animated: true, completion: nil)
    }
}
