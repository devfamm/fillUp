//
//  signUpViewController.swift
//  fillUp
//
//  Created by user245588 on 11/2/23.
//

import UIKit
import CoreData

class signUpViewController: UIViewController {
    //var context:NSManagedObjectContext!
    var loggedInUser:User!
    //private var contentViewController:UIViewController!
    var username = ""
    var password = ""
    
    @IBOutlet weak var messageText: UILabel!
    @IBOutlet weak var phoneField: UITextField!
    @IBOutlet weak var zipCodeField: UITextField!
    @IBOutlet weak var stateField: UITextField!
    @IBOutlet weak var cityField: UITextField!
    @IBOutlet weak var street2Field: UITextField!
    @IBOutlet weak var passwordConfField: UITextField!
    @IBOutlet weak var street1Field: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var userNameField: UITextField!
    @IBOutlet weak var lNameField: UITextField!
    @IBOutlet weak var fNameField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userNameField.text = username
        userNameField.isEnabled = false
        passwordField.isSecureTextEntry = true
        passwordField.text = password
        passwordField.isEnabled = false
                // Do any additional setup after loading the view.
    }
    

    @IBAction func submitSignUp(_ sender: Any) {

        if(
            fNameField.hasText && lNameField.hasText
            && userNameField.hasText
                             && passwordField.hasText
                             && passwordConfField.hasText
                             && passwordConfField.text == passwordField.text
                             && cityField.hasText
            )
        {
            let context = AppDelegate.sharedAppDelegate.coreDataStack.managedContext
            let newUser = NSEntityDescription.insertNewObject(forEntityName: "User", into: context) as! User

            
            /*let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.viewContext
            let entity = NSEntityDescription.entity(forEntityName: "User", in: context)
            let newUser = NSManagedObject(entity: entity!, insertInto: context)
            newUser.setValue(textField.text ?? "username12312235234", forKey: "username")*/
            
            //Name: -
            
            //let newUser = User(entity: entity, insertInto: users)
            newUser.street = street1Field.text!
            newUser.fname = fNameField.text!
            newUser.lname = lNameField.text!
            newUser.username = userNameField.text!
            newUser.password = passwordField.text!
            newUser.city = cityField.text!
            newUser.is_logged = true
            
            //Add User to the usersDic.
            
            //users.insert(newUser, at:0)
            /*do{
                AppDelegate.sharedAppDelegate.coreDataStack.saveContext()
                
            }*/
            dataStack.saveContext()

            loggedInUser = newUser
            getUsers()
            messageText.text=""
            performSegue(withIdentifier: "signedup_seg", sender: self)
        }
        else {
            messageText.text = "Invalid Inputs!"
            messageText.textColor = .red
        }
    }
    
    @IBAction func cancelSignUp(_ sender: Any) {
        self.performSegue(withIdentifier: "cancelsignup_seg", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "signedup_seg"{
            let mainTabBarController = segue.destination as! mainTabBarController
            mainTabBarController.loggedInUser = self.loggedInUser
        }
        else if segue.identifier == "cancelsignup_seg"{
            let loginViewController = segue.destination as! loginViewController
            loginViewController.loggedInUser = self.loggedInUser
        }
    }
    
        /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
   
}
