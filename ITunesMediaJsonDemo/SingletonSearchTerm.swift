//
//  SingletonSearchTerm.swift
//  ITunesMediaJsonDemo
//
//  Created by James Van Dillen on 4/19/15.
//  Copyright (c) 2015 James Van Dillen. All rights reserved.
//

import Foundation

class SingletonSearchTerm {
    
    static let sharedInstance = SingletonSearchTerm(searchTerm: "")
    
    var searchTerm: String?
    
    // Prevent object from being instantiated - inaccessible initializers ("private")
    private init(searchTerm: String) {
        println("Initialize singleton - once and only once.")
        self.searchTerm = searchTerm
    }
}

// Animation for scrolling attempt #1 -

// ObjC semi version I translated to Swift, but runs a bit slower due to shadowColor and offset
// Plus look how much code it requires - ugh.
//        // 1. Setup the CATransform3D structure
//        var rotation: CATransform3D
//        rotation = CATransform3DMakeRotation(1.57, 0.0, 0.7, 0.4)
//        rotation.m34 = 1.0 / -600
//
//        // 2. Define the initial state (Before the animation)
//        cell.layer.shadowColor = UIColor.blackColor().CGColor
//        cell.layer.shadowOffset = CGSizeMake(10, 10)
//        cell.alpha = 0
//
//        cell.layer.transform = rotation
//        cell.layer.anchorPoint = CGPointMake(0, 0.5)
//
//        // 3. Define the final state (After the animation) and commit the animation
//        UIView.beginAnimations("rotation", context: nil)
//        UIView.setAnimationDuration(0.8)
//        cell.layer.transform = CATransform3DIdentity
//        cell.alpha = 1
//        cell.layer.shadowOffset = CGSizeMake(0, 0)
//        UIView.commitAnimations()