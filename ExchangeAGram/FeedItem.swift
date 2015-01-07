//
//  FeedItem.swift
//  ExchangeAGram
//
//  Created by Koen Hendriks on 07/01/15.
//  Copyright (c) 2015 Koen Hendriks. All rights reserved.
//

import Foundation
import CoreData
@objc(FeedItem)
class FeedItem: NSManagedObject {

    @NSManaged var caption: String
    @NSManaged var image: NSData
    @NSManaged var thumbNail: NSData

}
