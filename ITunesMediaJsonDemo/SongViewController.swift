//
//  SongViewController.swift
//  ITunesMediaJsonDemo
//
//  Created by James Van Dillen on 5/4/15.
//  Copyright (c) 2015 James Van Dillen. All rights reserved.
//

import UIKit

import UIKit
import QuartzCore
import AVFoundation
import AVKit

class SongViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, ITunesAPIControllerProtocol {
    
    var collection: Collection?
    var reuseImage: UIImage?
    var elements = [Element]()
    var av = AVPlayerViewController()
    lazy var iTunesAPI: ITunesAPIController = ITunesAPIController(delegate: self)
    
    @IBOutlet weak var elementsTableView: UITableView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var albumImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let collectionTest = self.collection?.collectionId {
            reuseImage = UIImage(data: NSData(contentsOfURL: NSURL(string: self.collection!.thumbnailUrl100)!)!)
            albumImage.image = reuseImage
            iTunesAPI.lookupCollection(collectionTest)
            titleLabel.text = collection?.artistName
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillDisappear(animated: Bool) {
        if av.player != nil {
            av.player.pause()
        }
    }
    
    // MARK: - UITableViewDataSource Functions (required)
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return elements.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("elementCell") as! UITableViewCell
        let collectionElement = elements[indexPath.row]
        
        cell.textLabel?.text = collectionElement.name
        cell.detailTextLabel?.text = collectionElement.price
        
        return cell
    }
    
    // MARK: - Extra TableView Functions
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var element = elements[indexPath.row]
        
        let urlString = element.previewMediaUrl
        let nsurlPreviewUrl = NSURL(string: urlString)
        let player = AVPlayer(URL: nsurlPreviewUrl)
        let backgroundView = UIImageView(image: reuseImage!)
        
        av.player = player
        av.player.pause()
        
        av.view.frame = albumImage.frame
        self.addChildViewController(av)
        self.view.addSubview(av.view)
        
        av.contentOverlayView.addSubview(backgroundView)
        backgroundView.frame = av.view.bounds
        
        av.player.play()
        av.didMoveToParentViewController(self)
    }
    
    // 3D esque look to cells while scrolled
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        cell.layer.transform = CATransform3DMakeScale(0.1, 0.1, 1)
        UIView.animateWithDuration(0.3, animations: { cell.layer.transform = CATransform3DMakeScale(1, 1, 1)})
    }
    
    // MARK: - Custom API Protocol
    
    // Take dictionary of JSON results, create Element objects via JSON, store in an array
    func didReceiveITunesData(results: NSDictionary) {
        let resultsArray = results["results"] as! NSArray
        
        // Code to execute on the main thread (asynchronously)
        dispatch_async(dispatch_get_main_queue(), {
            self.elements = Element.createElementsWithJSON(resultsArray)
            self.elementsTableView!.reloadData()
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        })
    }
}
