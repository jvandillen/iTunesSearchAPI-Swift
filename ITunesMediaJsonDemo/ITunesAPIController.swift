//
//  ITunesAPIController.swift
//  ITunesMediaJsonDemo
//
//  Created by James Van Dillen on 4/16/15.
//  Copyright (c) 2015 James Van Dillen. All rights reserved.
//

import Foundation

protocol ITunesAPIControllerProtocol {
    func didReceiveITunesData(results: NSDictionary)
}

class ITunesAPIController {
    var delegate: ITunesAPIControllerProtocol
    
    init(delegate: ITunesAPIControllerProtocol) {
        self.delegate = delegate
    }
    
    func getDataWith(urlPath: String) {
        let url = NSURL(string: urlPath)
        let singletonSession = NSURLSession.sharedSession()
        
        // Get web request
        let task = singletonSession.dataTaskWithURL(url!,
            completionHandler: { data, response, error -> Void in
                
            var err: NSError?
            var jsonResult = NSJSONSerialization.JSONObjectWithData(data,
                options: NSJSONReadingOptions.MutableContainers,
                  error: &err) as! NSDictionary
            if (err != nil) {
                println("JSON fault: \(err!.localizedDescription)")
            }
                
            self.delegate.didReceiveITunesData(jsonResult)
        })
        task.resume()
    }
    
    func searchITunesWith(topic: String, tabType: SoundType) {
        
        var urlPath = "https://itunes.apple.com/search?term="
        
        let iTunesSearchTopic = topic.stringByReplacingOccurrencesOfString(" ",
            withString: "+",
               options: NSStringCompareOptions.CaseInsensitiveSearch,
                 range: nil)
        
            println("In searchITunes - tabType is \(tabType)")
        
            if let escapedSearchTerm = iTunesSearchTopic.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding) {
                if tabType == .Music {
                    urlPath += "\(escapedSearchTerm)&media=music&entity=album"
                    getDataWith(urlPath)
                }
                if tabType == .Audiobook {
                    urlPath += "\(escapedSearchTerm)&media=audiobook&entity=audiobook"
                    println("urlPath is \(urlPath)")
                    getDataWith(urlPath)
                }
            }
    }
    
    func lookupCollection(collectionId: Int) {
        getDataWith("https://itunes.apple.com/lookup?id=\(collectionId)&entity=song")
    }
    
    enum SoundType {
        case Music
        case Audiobook
        case Podcast
    }
}



