//
//  mainTabBarController.swift
//  fillUp
//
//  Created by devfamm on 11/2/23.
//

import UIKit
import CoreData

class mainTabBarController: UITabBarController {
    var context:NSManagedObjectContext!
    var loggedInUser:User!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        print("Called Prepare. In mainTabBarController.")
        if let selectedTabItem = selectedViewController as? homeViewController{
            selectedTabItem.loggedInUser = loggedInUser
        }
        else if let selectedTabItem = selectedViewController as? refillViewController{
            selectedTabItem.loggedInUser = loggedInUser
        }
        else if let selectedTabItem = selectedViewController as? profileTableViewController{
            selectedTabItem.loggedInUser = loggedInUser
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
