//
//  ScenarioQuestion.swift
//  Pods
//
//  Created by Lara Marie Reimer on 07.06.17.
//
//

import Foundation

open class ScenarioQuestion: Any {
    open let questionDescription : String
    open var isAnswered : Bool
    
    public init(questionDescription : String) {
        self.questionDescription = questionDescription
        self.isAnswered = false
    }
}
