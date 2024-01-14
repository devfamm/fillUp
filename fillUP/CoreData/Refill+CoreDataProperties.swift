//
//  Refill+CoreDataProperties.swift
//  fillUp
//
//  Created by devfamm on 11/30/23.
//
//

import Foundation
import CoreData
import UIKit

extension Refill {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Refill> {
        return NSFetchRequest<Refill>(entityName: "Refill")
    }

    @NSManaged public var gallons: Double
    @NSManaged public var type: String
    @NSManaged public var total: Double
    @NSManaged public var address: String
    @NSManaged public var date: Date
    @NSManaged public var username: String
    

}

extension Refill : Identifiable {

}
