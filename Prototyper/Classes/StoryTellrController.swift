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
    open var scenario : [ScenarioStep?] = []
    open var shouldShowScenarioSteps = true
    fileprivate var didPresentCurrentStep : Bool = false
    
    // MARK : - Getters & Setters
    
    open var currentScenarioStepNumber : Int? = 0 {
        didSet {
            PrototypeController.sharedInstance.setNotificationNumber(to: numberOfUnansweredQuestionsForCurrentStep())
            
            if !didPresentCurrentStep && shouldShowScenarioSteps {
                guard let rootVC = getTopViewController() else {
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
        guard let index = currentScenarioStepNumber, let currentScenario = scenario[index - 1] else { return nil }
        return currentScenario
    }
    
    var isLastStep : Bool {
        guard let index = currentScenarioStepNumber else { return false }
        return index == scenario.count
    }
    
    // MARK : - Helpers
    
    open func resetCurrentStep () {
        currentScenarioStepNumber = nil
    }
    
    private func numberOfUnansweredQuestionsForCurrentStep() -> Int {
        if let step = currentStep, let questions = step.questions {
            var numberOfUnansweredQuestions = 0
            
            for question in questions {
                if !question.isAnswered {
                    numberOfUnansweredQuestions += 1
                }
            }
            
            return numberOfUnansweredQuestions
        }
        return 0
    }
    
    private func getTopViewController() -> UIViewController? {
        guard let rootViewController = UIApplication.shared.keyWindow?.rootViewController else { return nil }
        
        var currentVC = rootViewController
        
        while let presentedVC = currentVC.presentedViewController {
            currentVC = presentedVC
        }
        
        return currentVC
    }
}
