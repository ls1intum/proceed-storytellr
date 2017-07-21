//
//  Utils.swift
//  Prototyper
//
//  Created by Lara Marie Reimer on 08.07.17.
//

import Foundation

class Utils {
    static func getTopViewController() -> UIViewController? {
        guard let rootViewController = UIApplication.shared.keyWindow?.rootViewController else { return nil }
        
        var currentVC = rootViewController
        
        while let presentedVC = currentVC.presentedViewController {
            currentVC = presentedVC
        }
        
        return currentVC
    }
}
