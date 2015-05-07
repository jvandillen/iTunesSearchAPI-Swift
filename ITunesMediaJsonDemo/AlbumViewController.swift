//
//  AlbumViewController.swift
//  ITunesMediaJsonDemo
//
//  Created by James Van Dillen on 5/4/15.
//  Copyright (c) 2015 James Van Dillen. All rights reserved.
//

import UIKit
import QuartzCore

class AlbumViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, ITunesAPIControllerProtocol {
    
    var collections = [Collection]()
    var thumbnailImageCache = [String : UIImage]()
    var ascDesc = false
    var iTunesAPI: ITunesAPIController!
    var localSearchTerm: String?
    
    @IBOutlet weak var collectionsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        iTunesAPI = ITunesAPIController(delegate: self)
    }
    
    override func viewWillAppear(animated: Bool) {
        if localSearchTerm != SingletonSearchTerm.sharedInstance.searchTerm && localSearchTerm != nil {
            self.localSearchTerm = SingletonSearchTerm.sharedInstance.searchTerm
            self.iTunesAPI.searchITunesWith(localSearchTerm!, tabType: .Music)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Search iTunes! Button
    
    // Use textField to prompt the user for a search topic
    @IBAction func searchITunesBtn(sender: UIBarButtonItem) {
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
            self.iTunesAPI.searchITunesWith(SingletonSearchTerm.sharedInstance.searchTerm!, tabType: .Music)
            
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
    
    // Reorder rows by name (asc|desc)
    @IBAction func reorderCollectionsByName(sender: UIBarButtonItem) {
        if ascDesc == false {
            ascDesc = true
            collections.sort({ $0.name < $1.name })
            self.collectionsTableView!.reloadData()
        } else {
            ascDesc = false
            collections.sort({ $0.name > $1.name })
            self.collectionsTableView!.reloadData()
        }
    }
    
    // MARK: - UITableViewDataSource Functions (required)
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return collections.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("collectionCell", forIndexPath: indexPath) as! UITableViewCell
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
            // Delegate creation of the array of Collection objects to the Collection class
            self.collections = Collection.createCollectionsWithJSON(resultsArray)
            self.collectionsTableView!.reloadData()
        })
    }
    
    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "toElement" {
            let elementViewController = segue.destinationViewController as! SongViewController
            
            let indexPath = collectionsTableView!.indexPathForSelectedRow()!.row
            let selectedCollection = self.collections[indexPath]
            
            elementViewController.collection = selectedCollection
        }
    }
}
