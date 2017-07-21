//
//  StoryTellrController.swift
//  Pods
//
//  Created by Lara Marie Reimer on 06.06.17.
//
//

import Foundation

open class StoryTellrController: NSObject {
    
    // MARK : - Properties
    
    open static let sharedInstance = StoryTellrController()
    open var shouldShowScenarioSteps = true
    var scenario = ScenarioDataHandler.sharedInstance.scenario
    fileprivate var didPresentCurrentStep : Bool = false
    fileprivate var hasQuestions : Bool = false
    
    // MARK : - Getters & Setters
    
    open var filename : String = "" {
        didSet {
            if let scenarioFromFile = Scenario.scenarioFromFile(named: filename) {
                if let scenarioFromDisk = scenario {
                    
                    // Only take the scenario from the file if it's different from the saved one.
                    if scenarioFromFile.id != scenarioFromDisk.id {
                        scenario = scenarioFromFile
                    }
                    
                } else {
                    scenario = scenarioFromFile
                }
            }
            
            // Set the correct scenario to the data source and calculate the number of overall unanswered questions.
            ScenarioDataHandler.sharedInstance.scenario = scenario
            calculateNumberOfUnansweredQuestionsForScenario()
        }
    }
    
    open var currentScenarioStepNumber : Int? = 0 {
        didSet {
            guard let currentScenario = scenario else { return }
            
            PrototypeController.sharedInstance.setNotificationNumber(to: numberOfUnansweredQuestionsForCurrentStep())
            
            if !didPresentCurrentStep && shouldShowScenarioSteps && !currentScenario.isCompleted {
                guard let rootVC = Utils.getTopViewController() else {
                    return
                }
                
                let infoVC = ScenarioInfoViewController.init(dataType : .ScenarioStep, isLastStep: isLastStep)
                                
                infoVC.modalPresentationStyle = .overFullScreen
                rootVC.present(infoVC, animated: true, completion: nil)
                didPresentCurrentStep = true
            }
        }
    }
    
    open var currentStep : ScenarioStep? {
        guard let index = currentScenarioStepNumber, let currentScenario = scenario?.steps[index - 1] else { return nil }
        return currentScenario
    }
    
    var isLastStep : Bool {
        guard let index = currentScenarioStepNumber, let currentScenario = scenario else { return false }
        let isLast = index == currentScenario.steps.count
        if isLast {
            currentScenario.isCompleted = true
        }
        return isLast
    }
    
    var numberOfUnansweredQuestionsInScenario : Int = 0 {
        didSet {
            if numberOfUnansweredQuestionsInScenario <= 0 {
                showSendFeedbackAlert()
            }
        }
    }
    
    // MARK : - Helpers
    
    open func resetCurrentStep() {
        currentScenarioStepNumber = nil
        didPresentCurrentStep = false
    }
    
    func appendFeedback(forFeedback: String) {
        guard let currentScenario = scenario else { return }
        
        var feedback = forFeedback
        
        if !currentScenario.userFeedback.isEmpty {
            feedback = "\n" + feedback
        }
        
        currentScenario.userFeedback = currentScenario.userFeedback + feedback
    }
    
    private func numberOfUnansweredQuestionsForCurrentStep() -> Int {
        if let step = currentStep {
            var numberOfUnansweredQuestions = 0
            
            for question in step.questions {
                if question.answer.isEmpty {
                    numberOfUnansweredQuestions += 1
                }
            }
            
            return numberOfUnansweredQuestions
        }
        return 0
    }
    
    private func calculateNumberOfUnansweredQuestionsForScenario() {
        guard let currentScenario = scenario else { return }
        var unansweredQuestions = 0
        
        for step in currentScenario.steps {
            for question in step.questions {
                hasQuestions = true
                
                if question.answer.isEmpty {
                    unansweredQuestions += 1
                }
            }
        }
        
        numberOfUnansweredQuestionsInScenario = unansweredQuestions
    }
    
    private func showSendFeedbackAlert() {
        guard let currentViewController = Utils.getTopViewController(), let currentScenario = scenario else { return }
        
        if !currentScenario.userFeedback.isEmpty {
            let alertController = UIAlertController(title: "Send your feedback", message: "You have answered all feedback questions. Do you want to submit your feedback?", preferredStyle: .alert)
            
            let sendAction = UIAlertAction(title: "Yes", style: .default) { (action) in
                // Send the feedback
                if !APIHandler.sharedAPIHandler.isLoggedIn {
                    self.askForNameAndSendFeedback()
                } else {
                    let name = UserDefaults.standard.string(forKey: UserDefaultKeys.Username)
                    if let name = name {
                        self.sendFeedback(name: name)
                    }
                }
            }
            
            let cancelAction = UIAlertAction(title: "No", style: .cancel) { (action) in
                // Do nothing
            }
            
            alertController.addAction(sendAction)
            alertController.addAction(cancelAction)
            
            currentViewController.present(alertController, animated: true, completion: nil)
        }
    }
    
    fileprivate func sendFeedback(name: String) {
        guard let currentScenario = scenario else { return }
        
        APIHandler.sharedAPIHandler.sendGeneralFeedback(description: currentScenario.userFeedback, name: name, success: {
        }, failure: { (error) in
        })
    }
    
    private func askForNameAndSendFeedback() {
        guard let currentViewController = Utils.getTopViewController() else { return }
        
        let alertController = UIAlertController(title: Texts.StateYourNameAlertSheet.Title, message: nil, preferredStyle: .alert)
        alertController.addTextField { textField in
            textField.placeholder = Texts.StateYourNameAlertSheet.Placeholder
            textField.text = UserDefaults.standard.string(forKey: UserDefaultKeys.Username)
        }
        alertController.addAction(UIAlertAction(title: Texts.StateYourNameAlertSheet.Send, style: .default, handler: { _ in
            let name = alertController.textFields?.first?.text ?? ""
            UserDefaults.standard.set(name, forKey: UserDefaultKeys.Username)
            self.sendFeedback(name: name)
        }))
        currentViewController.present(alertController, animated: true, completion: nil)
    }
}

