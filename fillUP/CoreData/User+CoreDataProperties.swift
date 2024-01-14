//
//  User+CoreDataProperties.swift
//  fillUp
//
//  Created by devfamm on 11/30/23.
//
//

import Foundation
import CoreData
import UIKit

extension User {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User")
    }

    @NSManaged public var username: String
    @NSManaged public var fname: String
    @NSManaged public var lname: String
    @NSManaged public var password: String
    @NSManaged public var street: String
    @NSManaged public var city: String
    @NSManaged @objc(is_logged) var is_logged: Bool

}

extension User : Identifiable {

}
