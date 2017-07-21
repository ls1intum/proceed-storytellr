//
//  ScenarioDataHandler.swift
//  Prototyper
//
//  Created by Lara Marie Reimer on 09.07.17.
//

import Foundation

class ScenarioDataHandler {
    static let sharedInstance = ScenarioDataHandler()
    
    struct Constants {
        static let fileName = "Scenario.json"
        static var localStorageURL: URL {
            get {
                let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
                return DocumentsDirectory.appendingPathComponent(Constants.fileName)
            }
        }
    }
    
    var scenario: Scenario?
    
    
    init() {
        do {
            let fileWrapper = try FileWrapper(url: Constants.localStorageURL, options: .immediate)
            guard let data = fileWrapper.regularFileContents else {
                throw NSError()
            }
            
            let decoder = JSONDecoder()
            scenario = try decoder.decode(Scenario.self, from: data)
        } catch _ {
            scenario = nil
            print("Could not get scenario")
        }
    }
    
    
    func saveToJSON() {
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(scenario)
            let jsonFileWrapper = FileWrapper(regularFileWithContents: data)
            try jsonFileWrapper.write(to: Constants.localStorageURL, options: FileWrapper.WritingOptions.atomic, originalContentsURL: nil)
        } catch _ {
            print("Could not save scenario")
        }
    }
}
