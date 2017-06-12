//
//  ScenarioStep.swift
//  StoryTellr
//
//  Created by Lara Marie Reimer on 27.05.17.
//  Copyright © 2017 Lara Marie Reimer. All rights reserved.
//

import Foundation

open class ScenarioStep: Any {
    open let stepNumber : Int
    open let stepDescription : String
    open let questions : [ScenarioQuestion]?
    
    public init(stepNumber : Int, stepDescription: String, questions: [ScenarioQuestion]?) {
        self.stepNumber = stepNumber
        self.stepDescription = stepDescription
        self.questions = questions
    }
}
