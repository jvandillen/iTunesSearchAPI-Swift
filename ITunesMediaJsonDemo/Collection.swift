//
//  Collection.swift
//  ITunesMediaJsonDemo
//
//  Created by James Van Dillen on 4/15/15.
//  Copyright (c) 2015 James Van Dillen. All rights reserved.
//

import Foundation

class Collection {
    let name: String
    let price: String
    let thumbnailUrl60: String
    let thumbnailUrl100: String
    let collectionId: Int
    let description: String
    let artistName: String
    let previewUrl: String
    
    init(name: String, price: String, thumbnailUrl60: String, thumbnailUrl100: String, collectionId: Int,
        description: String, artistName: String, previewUrl: String) {
        self.name = name
        self.price = price
        self.thumbnailUrl60 = thumbnailUrl60
        self.thumbnailUrl100 = thumbnailUrl100
        self.collectionId = collectionId
        self.description = description
        self.artistName = artistName
        self.previewUrl = previewUrl
    }
    
    // Class func - create media specific collection array from returned array of JSON objects
    class func createCollectionsWithJSON(results: NSArray) -> [Collection] {
        var collections = [Collection]()
        
        var jsonPrice: String?
        var jsonName: String?
        var jsonCollectionId: Int?
        var jsonArtistName: String? // <-- audiobook author
        var jsonDescription: String?
        
        var numberFormat = NSNumberFormatter()
        numberFormat.minimumFractionDigits = 2
        
        if results.count > 0 {
            println("Array size: \(results.count).")

            for result in results {
                if let jsonNameTest = result["collectionName"] as? String {
                    jsonName = jsonNameTest // <- still coming back wrapped in an optional
                }
                if let jsonArtistNameTest = result["artistName"] as? String {
                    jsonArtistName = jsonArtistNameTest
                }
                if let jsonPriceFloat = result["collectionPrice"] as? Float {
                    jsonPrice = "$\(numberFormat.stringFromNumber(jsonPriceFloat)!)"
                }
                if let jsonCollectionIdTest = result["collectionId"] as? Int {
                    jsonCollectionId = jsonCollectionIdTest
                }

                // Using this format -> if no cover art or description is provided return an empty string
                let jsonThumbnailUrl60  = result["artworkUrl60"]   as? String ?? ""
                let jsonThumbnailUrl100 = result["artworkUrl100"]  as? String ?? ""
                let jsonPreviewUrl      = result["previewUrl"]     as? String ?? ""
                var jsonDescriptionTest = result["description"]    as? String ?? ""
                
                // Remove the html tag elements from the description provided
                let jsonDescription = jsonDescriptionTest.stringByReplacingOccurrencesOfString("<[^>]+>",
                    withString: "",
                       options: .RegularExpressionSearch,
                         range: nil)
                
                println("Values: jsonName: \(jsonName!), jsonPrice: \(jsonPrice!), jsonThumb60: \(jsonThumbnailUrl60), jsonThumb100: \(jsonThumbnailUrl100), jsonCollectionId: \(jsonCollectionId!), jsonDescription: \(jsonDescription), jsonArtistName: \(jsonArtistName!), jsonPreviewUrl: \(jsonPreviewUrl)")
                
                var newCollection = Collection(name: jsonName!, price: jsonPrice!, thumbnailUrl60: jsonThumbnailUrl60, thumbnailUrl100: jsonThumbnailUrl100, collectionId: jsonCollectionId!, description: jsonDescription, artistName: jsonArtistName!,
                        previewUrl: jsonPreviewUrl)
                
                collections.append(newCollection)
            }
        }
        return collections
    }
}
