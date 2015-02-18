//
//  MapViewController.swift
//  ExchangeAGram
//
//  Created by Koen Hendriks on 08/02/15.
//  Copyright (c) 2015 Koen Hendriks. All rights reserved.
//

import UIKit
import MapKit
import CoreData

class MapViewController: UIViewController {

	@IBOutlet weak var mapView: MKMapView!
	
    override func viewDidLoad() {
        super.viewDidLoad()

		// Do any additional setup after loading the view.
		let request = NSFetchRequest(entityName: "FeedItem")
		let appDelegate:AppDelegate = (UIApplication.sharedApplication().delegate as AppDelegate)
		let context:NSManagedObjectContext = appDelegate.managedObjectContext!
		var error:NSError?
		let itemArray = context.executeFetchRequest(request, error: &error)
		println(error)
		
		// Display the feedItems we got back from coreData on our Map.
		if itemArray?.count > 0{
			for item in itemArray!{
				let location = CLLocationCoordinate2D(latitude: Double(item.latitude), longitude: Double(item.longitude))
				let span = MKCoordinateSpanMake(0.05, 0.05)
				let region = MKCoordinateRegionMake(location, span)
				mapView.setRegion(region, animated: true)
				
				let annotation = MKPointAnnotation()
				annotation.setCoordinate(location)
				annotation.title = item.caption
				
				mapView.addAnnotation(annotation)
				
			}
		}
		
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
}




















