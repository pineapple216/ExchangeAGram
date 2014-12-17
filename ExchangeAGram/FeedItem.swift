//
//  FeedItem.swift
//  ExchangeAGram
//
//  Created by Koen Hendriks on 17/12/14.
//  Copyright (c) 2014 Koen Hendriks. All rights reserved.
//

import Foundation
import CoreData

@objc (FeedItem)
class FeedItem: NSManagedObject {

    @NSManaged var caption: String
    @NSManaged var image: NSData

}
