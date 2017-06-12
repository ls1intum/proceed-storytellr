//
//  MarvelAdapter.swift
//  Prototyper
//
//  Created by Paul Schmiedmayer on 6/8/17.
//

import Foundation

struct MarvelPrototype: Codable, ProtoypeAdapter {
    let id: Int
    let name: String
    let images: [String: MarvelPage]
    
    var prototype: Prototype {
        get {
            let pages = images.sorted(by: {$0.0 < $1.0}).flatMap({$0.value.page})
            let protoype = Prototype(id: id, name: name, pages: pages)
            protoype.currentPage = pages.first
            return protoype
        }
    }
}

struct MarvelPage: Codable, PageAdapter {
    let id: Int
    let url: URL
    let hotspots: [MarvelTransition]
    
    var page: PrototypePage {
        get {
            let imageName = url.lastPathComponent
            return PrototypePage(id: id, imageName: imageName, transitions: hotspots.map{$0.prototyperTransition}, image: nil)
        }
    }
}

struct MarvelTransition: Codable, TransitionAdapter {
    let id: Int
    let x: Int
    let y: Int
    let x2: Int
    let y2: Int
    let dest_img_fk: Int
    let transition: MarvelTransitionTyp
    
    var prototyperTransition: PrototypeTransition {
        get {
            return PrototypeTransition(id: id, frame: CGRect(x: x, y: y, width: x2-x, height: y2-y), destinationID: dest_img_fk, transitionType: transition.prototyperTransitionTyp)
        }
    }
}

enum MarvelTransitionTyp: String, Codable, TransitionTypAdapter  {
    case none
    case pushright
    case pushleft
    
    var prototyperTransitionTyp: PrototypeTransitionTyp {
        get {
            switch self {
            case .none:
                return .none
            case .pushright:
                return .pushRight
            case .pushleft:
                return .pushLeft
            }
        }
    }
}
