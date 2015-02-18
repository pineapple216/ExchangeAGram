//
//  FeedViewController.swift
//  ExchangeAGram
//
//  Created by Koen Hendriks on 26/11/14.
//  Copyright (c) 2014 Koen Hendriks. All rights reserved.
//

import UIKit
import MobileCoreServices
import CoreData
import MapKit

class FeedViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, CLLocationManagerDelegate {

	@IBOutlet weak var collectionView: UICollectionView!
	
	var feedArray: [AnyObject] = []
	
	var locationManager: CLLocationManager!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		let backgroundImage = UIImage(named: "AutumnBackground")
		self.view.backgroundColor = UIColor(patternImage: backgroundImage!)
		
		// Do any additional setup after loading the view.
		locationManager = CLLocationManager()
		locationManager.delegate = self
		locationManager.desiredAccuracy = kCLLocationAccuracyBest
		locationManager.requestAlwaysAuthorization()
		
		locationManager.distanceFilter = 100.0
		locationManager.startUpdatingLocation()
		
    }
	
	override func viewDidAppear(animated: Bool) {
		let request = NSFetchRequest(entityName: "FeedItem")
		let appDelegate:AppDelegate = (UIApplication.sharedApplication().delegate as AppDelegate)
		let context:NSManagedObjectContext = appDelegate.managedObjectContext!
		
		feedArray = context.executeFetchRequest(request, error: nil)!
		collectionView.reloadData()
	}

	override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
	
	// MARK: - IBAction
	
	@IBAction func profileTapped(sender: UIBarButtonItem) {
		self.performSegueWithIdentifier("profileSegue", sender: nil)
	}
	
	
	@IBAction func snapBarButtonItemTapped(sender: UIBarButtonItem) {
		// Check if we have a camera available on the device we're using
		if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera){
			var cameraController = UIImagePickerController()
			cameraController.delegate = self
			cameraController.sourceType = UIImagePickerControllerSourceType.Camera
			
			let mediaTypes:[AnyObject] = [kUTTypeImage]
			cameraController.mediaTypes = mediaTypes
			cameraController.allowsEditing = false
			
			// Present the viewController to the user
			self.presentViewController(cameraController, animated: true, completion: nil)
		}
		// If the camera isn't available, let the user pick a picture from the photo album
		else if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.PhotoLibrary){
			var photoLibraryController = UIImagePickerController()
			photoLibraryController.delegate = self
			photoLibraryController.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
			
			let mediaTypes:[AnyObject] = [kUTTypeImage]
			photoLibraryController.mediaTypes = mediaTypes
			
			self.presentViewController(photoLibraryController, animated: true, completion: nil)
		}
		// If both the camera and photo album are unavailable, display an alert.
		else{
			var alertController = UIAlertController(title: "Alert", message: "Your device does not support the camera or photo Library", preferredStyle: UIAlertControllerStyle.Alert)
			
			alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
			self.presentViewController(alertController, animated: true, completion: nil)
		}
	}
	
	// MARK: - UIImagePickerControllerDelegate
	func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
		
		// Get the actual image and specify that it is a UIImage
		let image = info[UIImagePickerControllerOriginalImage] as UIImage
		// Present the image as imageData, an NSData object
		let imageData = UIImageJPEGRepresentation(image, 1.0)
		let thumbNailData = UIImageJPEGRepresentation(image, 0.2)
		
		
		// Get the managedObjectContext and our FeedItem Entity from our appDelegate
		let managedObjectContext = (UIApplication.sharedApplication().delegate as AppDelegate).managedObjectContext
		let entityDescription = NSEntityDescription.entityForName("FeedItem", inManagedObjectContext: managedObjectContext!)
		
		let feedItem = FeedItem(entity: entityDescription!, insertIntoManagedObjectContext: managedObjectContext!)
		
		// Setup the feedItem
		feedItem.image = imageData
		feedItem.caption = "test caption"
		feedItem.thumbNail = thumbNailData
		
		if let location = locationManager.location?{
			// Add location information for the feedItem
			feedItem.latitude = locationManager.location.coordinate.latitude
			feedItem.longitude = locationManager.location.coordinate.longitude
		}
		else{
			println("No location available")
		}
		
		
		// Create a Unique Identifier
		let UUID = NSUUID().UUIDString
		feedItem.uniqueID = UUID
		
		// Save the created feedItem to CoreData and append it to the feedArray
		(UIApplication.sharedApplication().delegate as AppDelegate).saveContext()
		feedArray.append(feedItem)
		
		self.dismissViewControllerAnimated(true, completion: nil)
		self.collectionView.reloadData()
	}
	
	
	// MARK: - UICollectionView DataSource
	func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
		return 1
	}
	
	func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return feedArray.count
	}
	
	func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
		
		var cell:FeedCell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath) as FeedCell
		
		let thisItem = feedArray[indexPath.row] as FeedItem
		
		cell.imageView.image = UIImage(data: thisItem.image)
		cell.captionLabel.text = thisItem.caption
		
		return cell
	}
	
	// MARK: - UICollectionViewDelegate
	func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
		// Get the selected item from the feedArray
		let thisItem = feedArray[indexPath.row] as FeedItem
		
		// Initialize an instance of the FilterViewController() and set it's FeedItem property
		var filterVC = FilterViewController()
		filterVC.thisFeedItem = thisItem
		
		self.navigationController?.pushViewController(filterVC, animated: false)
	}
	
	// MARK: - CLLocationManagerDelegate
	func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
		println("locations = \(locations)")
	}
	
	
}










