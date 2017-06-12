//
//  StoryTellrController.swift
//  Pods
//
//  Created by Lara Marie Reimer on 06.06.17.
//
//

import Foundation

open class StoryTellrController: NSObject {
    open static let sharedInstance = StoryTellrController()
    open var scenario : [ScenarioStep?] = []
    fileprivate var didPresentCurrentStep : Bool = false
    
    open var currentIndex : Int? = 0 {
        didSet {
            if !didPresentCurrentStep {
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
        guard let index = currentIndex, let currentScenario = scenario[index - 1] else { return nil }
        return currentScenario
    }
    
    var isLastStep : Bool {
        guard let index = currentIndex else { return false }
        return index == scenario.count
    }
    
    open func resetCurrentStep () {
        currentIndex = nil
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
