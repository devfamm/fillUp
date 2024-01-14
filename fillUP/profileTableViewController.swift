//
//  profileTableViewController.swift
//  fillUp
//
//  Created by devfamm on 11/2/23.
//

import UIKit
import CoreData

class profileTableViewController: UIViewController {
    //var context:NSManagedObjectContext!
    var loggedInUser:User!
    
    @IBOutlet weak var street2Field: UITextField!
    
    @IBOutlet weak var street1Field: UITextField!
    
    @IBOutlet weak var zipCodeField: UITextField!
    @IBOutlet weak var statePicker: UITextField!
    @IBOutlet weak var cityField: UITextField!
    @IBOutlet weak var firstNameField: UITextField!
    @IBOutlet weak var usernameLbl: UILabel!
    @IBOutlet weak var lastNameField: UITextField!
    @IBOutlet weak var phoneField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        var mainTabController = tabBarController as! mainTabBarController
        loggedInUser = mainTabController.loggedInUser
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        //Update Fields.
        updateFields()
    }
    override func viewDidDisappear(_ animated: Bool) {
        var mainTabController = tabBarController as! mainTabBarController
        mainTabController.loggedInUser = loggedInUser
    }
    
    //Button to add another address.
    @IBAction func addAddress(_ sender: Any) {
       updateUserProfile()
    }
    
    //Update Field values with current User Data.
    func updateFields(){
        usernameLbl.text = loggedInUser.username
        firstNameField.text = loggedInUser.fname
        lastNameField.text = loggedInUser.lname
        
        street1Field.text = loggedInUser.street
        cityField.text = loggedInUser.city
     
        
    }
    //Function: Update UserProfile.
    private func updateUserProfile(){
        
        if(firstNameField.hasText){loggedInUser.fname = firstNameField.text!}
        else{firstNameField.text=loggedInUser.fname}
        
        if(lastNameField.hasText){loggedInUser.lname = lastNameField.text!}
        else{lastNameField.text = loggedInUser.lname}
        
        
        
        //Address.
        var street = loggedInUser.street
        var city = loggedInUser.city
        
        if(street1Field.hasText){street = street1Field.text!}
       
        if(cityField.hasText){city = cityField.text!}
        loggedInUser.street = street
        loggedInUser.city = city
        
        //Update the fields.
        updateFields()
    }
    
    @IBAction func prompLoggOut(_ sender: Any) {
        print("are you sure you want to log out?")
        
        var refreshAlert = UIAlertController(title: "Log Out", message: "Sure you want to Log Out?", preferredStyle: UIAlertController.Style.alert)

        refreshAlert.addAction(UIAlertAction(title: "Confirm", style: .default, handler: { (action: UIAlertAction!) in
            //Perform logOut Segue.
            self.loggedInUser.is_logged = false
            
            if let row = users.firstIndex(where: {$0.username == self.loggedInUser.username}) {
                users[row] = self.loggedInUser
            }
            
            /*AppDelegate.sharedAppDelegate.coreDataStack.saveContext() // Save changes in Core Data
            DispatchQueue.main.async {
                
                getUsers()
            }*/
            self.performSegue(withIdentifier: "loggedOut", sender: self)
        }
          
        ))

        refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { (action: UIAlertAction!) in

            refreshAlert .dismiss(animated: true, completion: nil)
        }))
        present(refreshAlert, animated: true, completion: nil)
    }
    
    //Prepare Function befor performing segue.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "loggedOut"{
            AppDelegate.sharedAppDelegate.coreDataStack.saveContext()
            self.loggedInUser = User()
            let loggInViewController = segue.destination as! loginViewController
            loggInViewController.loggedInUser = self.loggedInUser
        }
    }
    
}
