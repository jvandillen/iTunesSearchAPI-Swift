//
//  Element.swift
//  ITunesMediaJsonDemo
//
//  Created by James Van Dillen on 4/19/15.
//  Copyright (c) 2015 James Van Dillen. All rights reserved.
//

import Foundation

class Element {
    let name: String
    let price: String
    let previewMediaUrl: String
    
    init(name: String, price: String, previewMediaUrl: String) {
        self.name = name
        self.price = price
        self.previewMediaUrl = previewMediaUrl
    }
    
    class func createElementsWithJSON(results: NSArray) -> [Element] {
        var elements = [Element]()
        
        var jsonName: String?
        var jsonPrice: String?
        var jsonPreviewMediaUrl: String?
        
        var numberFormat = NSNumberFormatter()
        numberFormat.minimumFractionDigits = 2
        
        if results.count > 0 {
            println("Array size: \(results.count).")
            for result in results {
                if let kind = result["kind"] as? String {
                    if kind == "song" {
                        if let jsonNameTest = result["trackName"] as? String {
                            jsonName = jsonNameTest
                        }
                        if let jsonPriceFloat = result["trackPrice"] as? Float {
                            jsonPrice = "$\(numberFormat.stringFromNumber(jsonPriceFloat)!)"
                        }
                        if let jsonPreviewMediaUrlTest = result["previewUrl"] as? String {
                            jsonPreviewMediaUrl = jsonPreviewMediaUrlTest
                        }
                        
                        println("Values: jsonName: \(jsonName!), jsonPrice: \(jsonPrice!), jsonPreviewMediaUrl: \(jsonPreviewMediaUrl!)")
                        
                        var element = Element(name: jsonName!, price: jsonPrice!, previewMediaUrl: jsonPreviewMediaUrl!)
                        
                        elements.append(element)
                    }
                }
            }
        }
        return elements
    }
}
