//
//  homeViewController.swift
//  fillUp
//
//  Created by user245588 on 11/2/23.
//

import UIKit
import CoreData

class homeViewController: UIViewController {
    var context:NSManagedObjectContext!
    var loggedInUser:User!
    
    @IBOutlet weak var greetLabel: UILabel!
    @IBOutlet weak var totalPointsLabel: UILabel!
    @IBOutlet weak var totalRefilsLabel: UILabel!
    @IBOutlet weak var totalGallonsLabel: UILabel!
    @IBOutlet weak var latestRefilInfo: UILabel!
    
    var totalPoints = 0
    var totalRefills = 0
    var totalGallons = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        var mainTabController = tabBarController as! mainTabBarController
        loggedInUser = mainTabController.loggedInUser
        
        updateFields()

    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    override func viewDidDisappear(_ animated: Bool) {
        var mainTabController = tabBarController as! mainTabBarController
        mainTabController.loggedInUser = loggedInUser
        updateFields()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        updateFields()
    }
    
    //Update Field values with current User Data.
    func updateFields(){
        greetLabel.text = "Hey " + loggedInUser.fname
        
        getRefills()
        
        print("Refills Count:")
        print(refills.count)
        print(refills)
        let loggedInUserRefills = refills.filter{
            $0.username == loggedInUser.username
        }
        
        if loggedInUserRefills.count > 0{
            totalGallons = 0
            for refill in loggedInUserRefills{
                totalGallons += Int(refill.gallons)
            }
            //Number of refills plus 15 percent.
            totalPoints = 2*loggedInUserRefills.count + Int(Double(totalGallons) * 0.15 )
        }
        
        totalRefills = loggedInUserRefills.count
        totalPointsLabel.text = "Total Points: \(totalPoints)"
        totalGallonsLabel.text = "Total Gallons: \(totalGallons)"
        totalRefilsLabel.text = "Total Refills: \(totalRefills)"
        
        
        if loggedInUserRefills.isEmpty{
            latestRefilInfo.text = "You don't have any Refills,\n Go ahead and request a Refill \n⬇️"
            //latestRefilInfo.font = latestRefilInfo.font.withSize(14)
        }
        else{
            latestRefilInfo.text = "Latest Refill:\n \(loggedInUserRefills.first!.gallons) \(loggedInUserRefills.first!.type) on \(loggedInUserRefills.first?.date.description)"
        }
    }

}
