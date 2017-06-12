//
//  Prototype.swift
//  Prototyper
//
//  Created by Paul Schmiedmayer on 5/28/17.
//
//

import Foundation

#if os(OSX)
    import Cocoa
    
    typealias Image = NSImage
    typealias ImageView = NSImageView
#elseif os(iOS)
    import UIKit
    
    typealias Image = UIImage
    typealias ImageView = UIImageView
#endif

//MARK: - Prototype

class Prototype: Codable {
    let id: Int
    let name: String
    var pages: [PrototypePage]
    var currentPage: PrototypePage?
    
    init(id: Int, name: String, pages: [PrototypePage]) {
        self.id = id
        self.name = name
        self.pages = pages
    }
    
    static func prototypeFromContainer(named containerName: String) -> Prototype? {
        guard let path = Bundle.main.path(forResource: containerName, ofType: ".bundle"), let bundle = Bundle.init(path: path) else {
            print("Bundle named \"\(containerName)\" could not be found in the main bundle. Check if you added the bundle to the target.")
            return nil
        }
        
        guard let contentPath = bundle.path(forResource: "data", ofType: "json") else {
            print("The container did not contain a JSON file to parse")
            return nil
        }
        
        do {
            let content = try NSString(contentsOfFile: contentPath, encoding: String.Encoding.utf8.rawValue) as String
            let decoder = JSONDecoder()
            print("Delete once own data fromat is used")
            let marvelPrototype = try decoder.decode(MarvelPrototype.self, from: content.data(using: .utf8)!)
            let prototype = marvelPrototype.prototype
            
            for page in prototype.pages {
                guard let path = bundle.path(forResource: page.imageName, ofType: "jpg", inDirectory: "/images", forLocalization: nil), let image = Image(contentsOfFile: path) else {
                    return nil
                }
                page.image = image
            }
            return prototype
        } catch {
            print("The container could not be parsed. Please be sure that you are using the latest version of the Prototyper framework as well as the latest Container ")
            return nil
        }
    }
}

protocol ProtoypeAdapter {
    var prototype: Prototype { get }
}

//MARK: - PrototypePage

class PrototypePage: Codable {
    let id: Int
    let imageName: String
    let transitions: [PrototypeTransition]
    var image: Image?
    
    private enum CodingKeys: String, CodingKey {
        case id
        case imageName
        case transitions
    }
    
    init(id: Int, imageName: String, transitions: [PrototypeTransition], image: Image?) {
        self.id = id
        self.imageName = imageName
        self.transitions = transitions
        self.image = image
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try values.decode(Int.self, forKey: .id)
        imageName = try values.decode(String.self, forKey: .imageName)
        transitions = try values.decode([PrototypeTransition].self, forKey: .transitions)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(imageName, forKey: .imageName)
        try container.encode(transitions, forKey: .transitions)
    }
}

protocol PageAdapter {
    var page: PrototypePage { get }
}

//MARK: - PrototypeTransition

enum PrototypeTransitionTyp: String, Codable {
    case none
    case pushRight
    case pushLeft
}

class PrototypeTransition: Codable {
    let id: Int
    let frame: CGRect
    let destinationID: Int
    let transitionType: PrototypeTransitionTyp
    
    init(id: Int, frame: CGRect, destinationID: Int, transitionType: PrototypeTransitionTyp) {
        self.id = id
        self.frame = frame
        self.destinationID = destinationID
        self.transitionType = transitionType
    }
    
    #if os(iOS)
    func performTransition(prototyperView: PrototypeView, completion: @escaping ((Bool) -> Void)) {
        guard let image = prototyperView.prototype?.pages.filter({$0.id == self.destinationID}).first?.image else {
            completion(false)
            return
        }
        
        let imageView = ImageView(image: image)
        imageView.contentMode = .scaleToFill
        
        switch transitionType {
        case .none:
            completion(false)
        case .pushRight:
            imageView.frame = CGRect(x: prototyperView.bounds.size.width, y: 0, width: prototyperView.bounds.size.width, height: prototyperView.bounds.size.height)
            prototyperView.addSubview(imageView)
            UIView.animate(withDuration: PrototypeUI.AnimationTime, animations: {
                imageView.frame = CGRect(x: 0, y: 0, width: prototyperView.bounds.size.width, height: prototyperView.bounds.size.height)
            }, completion: { (finished: Bool) in
                imageView.removeFromSuperview()
                completion(finished)
            })
        case .pushLeft:
            imageView.frame = CGRect(x: -prototyperView.bounds.size.width, y: 0, width: prototyperView.bounds.size.width, height: prototyperView.bounds.size.height)
            prototyperView.addSubview(imageView)
            UIView.animate(withDuration: PrototypeUI.AnimationTime, animations: {
                imageView.frame = CGRect(x: 0, y: 0, width: prototyperView.bounds.size.width, height: prototyperView.bounds.size.height)
            }, completion: { (finished: Bool) in
                imageView.removeFromSuperview()
                completion(finished)
            })
        }
    }
    #endif
}

protocol TransitionAdapter {
    var prototyperTransition: PrototypeTransition { get }
}

protocol TransitionTypAdapter {
    var prototyperTransitionTyp: PrototypeTransitionTyp { get }
}

//MARK: - Codable Extensions

extension CGRect: Codable {
    private enum CodingKeys: String, CodingKey {
        case origin
        case size
    }
    
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        origin = try values.decode(CGPoint.self, forKey: .origin)
        size = try values.decode(CGSize.self, forKey: .origin)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(origin, forKey: .origin)
        try container.encode(size, forKey: .size)
    }
}

extension CGPoint: Codable {
    private enum CodingKeys: String, CodingKey {
        case x
        case y
    }
    
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        x = try values.decode(CGFloat.self, forKey: .x)
        y = try values.decode(CGFloat.self, forKey: .y)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(x, forKey: .x)
        try container.encode(y, forKey: .y)
    }
}

extension CGSize: Codable {
    private enum CodingKeys: String, CodingKey {
        case width
        case height
    }
    
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        width = try values.decode(CGFloat.self, forKey: .width)
        height = try values.decode(CGFloat.self, forKey: .height)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(width, forKey: .width)
        try container.encode(height, forKey: .height)
    }
}
