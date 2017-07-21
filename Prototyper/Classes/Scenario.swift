//
//  Scenario.swift
//  Prototyper
//
//  Created by Lara Marie Reimer on 08.07.17.
//

import Foundation

open class Scenario: Codable {
    var id : String
    var steps : [ScenarioStep]
    var isCompleted : Bool
    var userFeedback : String
    
    public init(id: String, steps: [ScenarioStep], isCompleted: Bool, userFeedback: String) {
        self.id = id
        self.steps = steps
        self.isCompleted = isCompleted
        self.userFeedback = userFeedback
    }
    
    static func scenarioFromFile(named fileName: String) -> Scenario? {
        guard let contentPath = Bundle.main.path(forResource: fileName, ofType: "json") else {
            print("The project did not contain a JSON file to parse")
            return nil
        }
        
        do {
            let content = try NSString(contentsOfFile: contentPath, encoding: String.Encoding.utf8.rawValue) as String
            let decoder = JSONDecoder()
            let scenario = try decoder.decode(Scenario.self, from: content.data(using: .utf8)!)
            
            return scenario
        } catch {
            print("The scenario could not be parsed. Please be sure that you are using the latest version of the Prototyper framework as well as the correct json format ")
            return nil
        }
    }
}
