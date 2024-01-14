//
//  ViewController.swift
//  fillUp
//
//  Created by devfamm on 10/26/23.
//

import UIKit
import SwiftUI
import CoreData

/*
struct Address{
    var street1=""
    var street2=""
    var city=""
    var state=""
    var zipCode=00000
}

struct Refill{
    var gallons = 0.00
    var total = 0.00
    var type = "regular"
    let date = Date()
    var address = Address()
}

class User
{
    var fname:String = ""
    var lname:String  = ""
    var username:String = ""
    var email = ""
    var password = ""
    var addresses=[Address]()
    var refills=[Refill]()
    var phone = ""
    //Initializer with parameters.
    init(fname: String, lname: String, username: String, email: String = "", password: String = "", addresses: [Address] = [Address](), refills: [Refill] = [Refill](), phone: String = "") {
        self.fname = fname
        self.lname = lname
        self.username = username
        self.email = email
        self.password = password
        self.addresses = addresses
        self.refills = refills
        self.phone = phone
    }
    //Default inittializer.
    init(){
    }
}
*/

//Store testing user.
/*var users = ["test":User(fname:"Test", lname:"Last", username:"test", email:"test@email.com", password:"pass", addresses: [(Address(street1: "121 Main St", street2: "45", city: "Houston", state: "TX", zipCode: 77055))],refills:[Refill()], phone:"1234567890")]
*/
var users:[User] = []
var refills:[Refill] = []

let context = AppDelegate.sharedAppDelegate.coreDataStack.managedContext
let dataStack = AppDelegate.sharedAppDelegate.coreDataStack

class loginViewController: UIViewController {
    //var context:NSManagedObjectContext!
    var loggedInUser:User!
    
    @IBOutlet weak var messageText: UILabel!
    @IBOutlet weak var userNameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    private var username=""
    private var password=""
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        passwordField.isSecureTextEntry = true
        //messageText.text = "Hey \(loggedInUser.fname)"
        
        createDumValues()
        
        getUsers()
        getRefills()
    }

    @IBAction func logInSubmit(_ sender: Any) {

        checkLogin()
    }
    private func checkLogin(){
        if (userNameField.hasText && passwordField.hasText){
            
            
            let userFetch: NSFetchRequest<User> = User.fetchRequest()
            userFetch.predicate = NSPredicate(
                format: "username == %@", userNameField.text!)
            userFetch.fetchLimit = 1
            let sortByDate = NSSortDescriptor(key: #keyPath(User.username), ascending: false)
            userFetch.sortDescriptors = [sortByDate]
            let result:[User]
            let managedContext = AppDelegate.sharedAppDelegate.coreDataStack.managedContext
            do {
                result = try managedContext.fetch(userFetch)
            } catch let error as NSError {
                result = []
                print("Fetch error: \(error) description: \(error.userInfo)")
            }
            
            if let user = result.first{
                if user.password == passwordField.text{
                    user.is_logged = true
                    dataStack.saveContext()
                    self.loggedInUser = user
                    //self.context = managedContext
                    performSegue(withIdentifier: "loggedIn_seg", sender: self)
                }
                else{
                    messageText.text = "Invalid Credentials!"
                }
            }
            else{
                username = userNameField.text!
                password = passwordField.text!
                performSegue(withIdentifier: "signup_seg", sender: self)
            }
            
        }
    }
    
    //Check session.
    func checkSession(){
        
        let userFetch: NSFetchRequest<User> = User.fetchRequest()
        userFetch.predicate = NSPredicate(
            format: "is_logged == %d", 1)
        userFetch.fetchLimit = 1
        let sortByDate = NSSortDescriptor(key: #keyPath(User.username), ascending: false)
        userFetch.sortDescriptors = [sortByDate]
        let result:[User]
        do {
            result = try context.fetch(userFetch)
        } catch let error as NSError {
            result = []
            print("Fetch error: \(error) description: \(error.userInfo)")
        }
        if !result.isEmpty{
            print("Found Logged In user.")
            loggedInUser = result.first
            self.performSegue(withIdentifier: "loggedIn_seg", sender: self)

        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "loggedIn_seg"{
            let mainTabBarController =  segue.destination as! mainTabBarController
            mainTabBarController.loggedInUser = self.loggedInUser
            dataStack.saveContext()
        }
        else if segue.identifier == "signup_seg"{
            let signUpViewController =  segue.destination as! signUpViewController
            
            signUpViewController.username = username
            signUpViewController.password = password
            
            //signUpViewController.loggedInUser = self.loggedInUser
        }
        
    }
    
    //Get Usesrs.
    /*func getUsers() {
        let userFetch: NSFetchRequest<User> = User.fetchRequest()
        let sortByDate = NSSortDescriptor(key: #keyPath(User.username), ascending: false)
        userFetch.sortDescriptors = [sortByDate]
        do {
            let managedContext = AppDelegate.sharedAppDelegate.coreDataStack.managedContext
            let results = try managedContext.fetch(userFetch)
            users = results
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
        } catch let error as NSError {
            print("Fetch error: \(error) description: \(error.userInfo)")
        }
    }*/
    
    //Check for user logged In.
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        checkSession()
    }
}

