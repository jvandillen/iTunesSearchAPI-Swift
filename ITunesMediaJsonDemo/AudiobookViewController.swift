//
//  AudiobookViewController.swift
//  ITunesMediaJsonDemo
//
//  Created by James Van Dillen on 5/4/15.
//  Copyright (c) 2015 James Van Dillen. All rights reserved.
//

import UIKit

import UIKit
import QuartzCore

class AudiobookViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, ITunesAPIControllerProtocol {
    
    var collections = [Collection]()
    var iTunesAPI: ITunesAPIController!
    var thumbnailImageCache = [String : UIImage]()
    var ascDesc = false
    var localSearchTerm: String?
    
    @IBOutlet weak var audioBookTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        iTunesAPI = ITunesAPIController(delegate: self)
    }
    
    override func viewWillAppear(animated: Bool) {
        if localSearchTerm != SingletonSearchTerm.sharedInstance.searchTerm {
            self.localSearchTerm = SingletonSearchTerm.sharedInstance.searchTerm
            self.iTunesAPI.searchITunesWith(localSearchTerm!, tabType: .Audiobook)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func ascDesc(sender: UIBarButtonItem) {
        if ascDesc == false {
            ascDesc = true
            collections.sort({ $0.name < $1.name })
            self.audioBookTableView!.reloadData()
        } else {
            ascDesc = false
            collections.sort({ $0.name > $1.name })
            self.audioBookTableView!.reloadData()
        }
    }
    
    @IBAction func searchItunesBtn(sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Search iTunes!",
            message: "Enter a band, artist, podcast or movie search subject:",
            preferredStyle: .Alert)
        
        let dismissHandler = {
            (action: UIAlertAction!) in
            self.dismissViewControllerAnimated(true, completion: nil)
        }
        
        // Save singleton and search topic
        let saveSearchTerm = {
            (action: UIAlertAction!) -> Void in
            let textField = alert.textFields![0] as! UITextField
            
            // Save to the singleton property
            SingletonSearchTerm.sharedInstance.searchTerm = textField.text
            UIApplication.sharedApplication().networkActivityIndicatorVisible = true
            self.localSearchTerm = SingletonSearchTerm.sharedInstance.searchTerm
            self.iTunesAPI.searchITunesWith(SingletonSearchTerm.sharedInstance.searchTerm!, tabType: .Audiobook)
            
            self.dismissViewControllerAnimated(true, completion: nil)
        }
        
        // Add Alerts to the UIAlertController and assign behavior
        alert.addAction(UIAlertAction(title: "OK",
            style: .Cancel,
            handler: saveSearchTerm))
        
        alert.addAction(UIAlertAction(title: "Cancel",
            style: .Destructive,
            handler: dismissHandler))
        
        alert.addTextFieldWithConfigurationHandler({ textField in
            textField.placeholder = "Enter search subject!"})
        
        // Present the UIAlertController
        presentViewController(alert, animated: true, completion: nil)
    }
    
    // MARK: - UITableViewDataSource Functions (required)
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return collections.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("audiobookCell", forIndexPath: indexPath) as! UITableViewCell
        let collection = self.collections[indexPath.row]
        
        cell.detailTextLabel?.text = collection.price
        cell.textLabel!.text = collection.name
        // Explicitly set cell placeholder image or it won't load on first search - does load on the others that follow
        cell.imageView!.image = UIImage(named: "DJ-50.png")
        
        let thumbnailUrlString = collection.thumbnailUrl60
        let thumbnailUrl = NSURL(string: thumbnailUrlString)!
        
        // Is the image cache there?
        if let imageCache = thumbnailImageCache[thumbnailUrlString] {
            cell.imageView?.image = imageCache
        }
        else {
            // Go get the image with the url
            let request = NSURLRequest(URL: thumbnailUrl)
            
            NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler:
                {(response: NSURLResponse!, data: NSData!, error: NSError!) -> Void in
                    
                    if error == nil {
                        let image = UIImage(data: data)
                        // Store the image in to our cache
                        self.thumbnailImageCache[thumbnailUrlString] = image
                        
                        // Update the cell
                        dispatch_async(dispatch_get_main_queue(), {
                            if let cellToUpdate = tableView.cellForRowAtIndexPath(indexPath) {
                                cellToUpdate.imageView!.image = image
                            }
                        })
                    }
                    else {
                        println("Error: \(error.localizedDescription)")
                    }
                })
        }
        return cell
    }
    
    // MARK: - Extra TableView Functions
    
    // 3D esque look to cells while scrolled
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        cell.layer.transform = CATransform3DMakeScale(0.1, 0.1, 1)
        UIView.animateWithDuration(0.3, animations: { cell.layer.transform = CATransform3DMakeScale(1, 1, 1)})
    }
    
    // MARK: - Custom API Protocol
    
    // Take the JSON results, create Collection objects via JSON, store in an array
    func didReceiveITunesData(results: NSDictionary) {
        let resultsArray = results["results"] as! NSArray
        
        // Code to execute on the main thread (asynchronously)
        dispatch_async(dispatch_get_main_queue(), {
            self.collections = Collection.createCollectionsWithJSON(resultsArray)
            self.audioBookTableView!.reloadData()
        })
    }
    
    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "toEps" {
            let elementViewController = segue.destinationViewController as! BookPlayerViewController
            
            let indexPath = audioBookTableView!.indexPathForSelectedRow()!.row
            let selectedCollection = self.collections[indexPath]
            
            elementViewController.collection = selectedCollection
        }
    }
}
