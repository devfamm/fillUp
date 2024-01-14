//
//  functions.swift
//  fillUp
//
//  Created by user245588 on 11/17/23.
//

import Foundation
import CoreData

//Print Refill in string mode.
func printRefill(refill:Refill)->String{
    return "\(refill.date) \(refill.gallons) \(refill.type) \(refill.address)"
}

//Validate email string.
func validateEmail(email:String)->Bool{
let emailPattern = #"^\S+@\S+\.\S+$"#
var result = email.range(
    of: emailPattern,
    options: .regularExpression
)

return (result != nil)
}

//Validate Phone Number string
func validatePhone(phone:String)->Bool{
let phonePattern = #"^\(?\d{3}\)?[ -]?\d{3}[ -]?\d{4}$"#
var result = phone.range(
    of: phonePattern,
    options: .regularExpression
)

return (result != nil)
}

//Validate Zip Code string
func validateZipCode(phone:String)->Bool{
let zipCodePattern = #"^\d{5}$"#
var result = phone.range(
    of: zipCodePattern,
    options: .regularExpression
)
return (result != nil)
}

//Get Usesrs.
func getUsers() {
    let userFetch: NSFetchRequest<User> = User.fetchRequest()
    let sortByDate = NSSortDescriptor(key: #keyPath(User.username), ascending: false)
    userFetch.sortDescriptors = [sortByDate]
    do {
        let managedContext = AppDelegate.sharedAppDelegate.coreDataStack.managedContext
        let results = try managedContext.fetch(userFetch)
        users = results
        print("Users:\(users)")
    } catch let error as NSError {
        print("Fetch error: \(error) description: \(error.userInfo)")
    }
}
//Get Refills.
func getRefills() {
    let refillFetch: NSFetchRequest<Refill> = Refill.fetchRequest()
    let sortByDate = NSSortDescriptor(key: #keyPath(Refill.date), ascending: false)
    refillFetch.sortDescriptors = [sortByDate]
    do {
        let managedContext = AppDelegate.sharedAppDelegate.coreDataStack.managedContext
        let results = try managedContext.fetch(refillFetch)
        refills = results
        print("refills:\(refills)")

    } catch let error as NSError {
        print("Fetch error: \(error) description: \(error.userInfo)")
    }
}



func createDumValues(){
    //let context = AppDelegate.sharedAppDelegate.coreDataStack.managedContext
    let newUser = NSEntityDescription.insertNewObject(forEntityName: "User", into: context) as! User

    
    
    
    //let newUser = User(entity: entity, insertInto: users)
    newUser.street = "Street m"
    newUser.fname = "User 1"
    newUser.lname = "User1 Last"
    newUser.username = "test1"
    newUser.password = "pass"
    newUser.city = "Htown"
    newUser.is_logged = false
    
    let refill = NSEntityDescription.insertNewObject(forEntityName: "Refill", into: context) as! Refill
    
    refill.address = "Street 1"
    refill.date = Date()
    refill.gallons = 10.3
    refill.username = "test1"
    refill.type = "regular"
    refill.total = 10.3 * 2.85
    
    do{
        try context.save()
    }
    catch{
        print("Failed to save.")
    }
    
    dataStack.saveContext()
    
}



