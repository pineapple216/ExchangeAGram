//
//  FilterViewController.swift
//  ExchangeAGram
//
//  Created by Koen Hendriks on 17/12/14.
//  Copyright (c) 2014 Koen Hendriks. All rights reserved.
//

import UIKit

class FilterViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

	var thisFeedItem: FeedItem!
	
	var collectionView: UICollectionView!
	
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
		// Create a new flowLayout and specify the insets, to create a nice border around each image
		// and specify the itemSize, i.e. the size of each cell
		let layout = UICollectionViewFlowLayout()
		
		layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
		layout.itemSize = CGSize(width: 150.0, height: 150.0)
		
		// Create the actual UICollectionView instance
		collectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
		collectionView.dataSource = self
		collectionView.delegate = self
		collectionView.backgroundColor = UIColor.whiteColor()
		self.view.addSubview(collectionView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
	// MARK: - UICollectionView DataSource
	func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return 0
	}
	
	func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
		return UICollectionViewCell()
	}

}



















