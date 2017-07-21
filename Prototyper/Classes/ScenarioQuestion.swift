//
//  ScenarioQuestion.swift
//  Pods
//
//  Created by Lara Marie Reimer on 07.06.17.
//
//

import Foundation

open class ScenarioQuestion: Codable {
    open let questionDescription : String
    open var answer : String
    
    public init(questionDescription : String, answer : String) {
        self.questionDescription = questionDescription
        self.answer = answer
    }
}
