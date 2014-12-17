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

class FeedViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

	@IBOutlet weak var collectionView: UICollectionView!
	
	var feedArray: [AnyObject] = []
	
	override func viewDidLoad() {
		super.viewDidLoad()

		// Do any additional setup after loading the view.
		let request = NSFetchRequest(entityName: "FeedItem")
		let appDelegate:AppDelegate = (UIApplication.sharedApplication().delegate as AppDelegate)
		let context:NSManagedObjectContext = appDelegate.managedObjectContext!
		
		feedArray = context.executeFetchRequest(request, error: nil)!
		
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
		
		// Get the managedObjectContext and our FeedItem Entity from our appDelegate
		let managedObjectContext = (UIApplication.sharedApplication().delegate as AppDelegate).managedObjectContext
		let entityDescription = NSEntityDescription.entityForName("FeedItem", inManagedObjectContext: managedObjectContext!)
		
		let feedItem = FeedItem(entity: entityDescription!, insertIntoManagedObjectContext: managedObjectContext!)
		
		// Setup the feedItem
		feedItem.image = imageData
		feedItem.caption = "test caption"
		
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
	
	

}










