//
//  refillViewController.swift
//  fillUp
//
//  Created by devfamm on 11/2/23.
//

import UIKit
import MapKit
import CoreLocation
import CoreLocationUI
import CoreData

class refillViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, MKMapViewDelegate, CLLocationManagerDelegate{
    //var context:NSManagedObjectContext!
    var loggedInUser:User!
    
    @IBOutlet weak var submitButton: BlueBorderedButton!
    var locationManager = CLLocationManager()
    @IBOutlet weak var currentLocationBtn:CLLocationButton!
    @IBOutlet weak var fuelGradePicker: UIPickerView!
    
    @IBOutlet weak var timeLbl:UILabel!
    
    @IBOutlet weak var totalLabel: UILabel!
    
    @IBOutlet weak var addressLbl: UILabel!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var map: MKMapView!
    @IBOutlet weak var fuelGradeField: UITextField!
   
    var deliveryAddress = ""
    var pickerData = ["regular", "plus", "premium", "electric"]
    let priceIndex = ["regular":2.85, "plus":3.15, "premium":4.10, "electric": 0.75]
    
    @IBOutlet weak var gallonsField: UITextField!
    
    //@IBOutlet weak var requestBySwitch: UISwitch!
    
    //Loading View.
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.

        
        
        //Set the UIPicker view delegate and datasource.
        fuelGradePicker.delegate = self
        fuelGradePicker.dataSource = self
        
        //Map View delegate.
        map.delegate  = self
        
        //Hide MapView.
        map.isHidden = true
        //hide or show total and submit.
        calculateTotal()
        
        //Location Manager Delegate.
        locationManager.delegate = self
        
        //MinMax Date picker.
        setMinMaxDatePicker()
        
        //Switch controller.
        //requestBySwitch.preferredStyle = .checkbox
        
        //Gallons Field Type.
        gallonsField.keyboardType = .numberPad
        
        //Get the current loggedIn User.
        let mainTabController = tabBarController as! mainTabBarController
        loggedInUser = mainTabController.loggedInUser
        
        //Current Location
        currentLocationBtn.addTarget(self, action:#selector(userPressedLocationButton), for: .touchUpInside)
        
        //Set Address Label.
        deliveryAddress = "\(loggedInUser.street), \(loggedInUser.city)"
        updateAddressLbl(address:deliveryAddress)
        
    }
    
    //GET the users' location once clicked.
    @objc func userPressedLocationButton(){
        locationManager.startUpdatingLocation()
    }
    
    //Check valid fuel.
    func isvalidFuel(fuel:String)->Bool{
        for fuelGrade in pickerData{
            if fuel.lowercased() == fuelGrade{
                return true
            }
            
        }
        return false
    }
    
    //Handle submittion of refill.
    @IBAction func submitRefill(_ sender: Any) {
        let selectedFuel = pickerData[fuelGradePicker.selectedRow(inComponent: 0)]
        let gallonsValue = Int(gallonsField.text!)!
        
            var total:Double = Double(gallonsValue) * priceIndex[selectedFuel]!
            total = round(total * 100) / 100.0
            
            //var refill = Refill()
            let context = AppDelegate.sharedAppDelegate.coreDataStack.managedContext
            let refill = NSEntityDescription.insertNewObject(forEntityName: "Refill", into: context) as! Refill
        
            //Set total value.
            refill.total=total
            refill.gallons = Double(gallonsValue)
            //Set delivery address.
            refill.address = deliveryAddress
            refill.type = selectedFuel
            refill.username = loggedInUser.username
            refill.date = datePicker.date
            //add to the list of reflls of that user.
            dataStack.saveContext()
        
            getRefills()
            let mainTabController = self.tabBarController as! mainTabBarController
            //print("Passed refering to tabBar")

            mainTabController.selectedIndex = 0
            //print("Passed changing the index Assignment")
                    
    }
    
    // MARK: - FuelGradePicker
    //Number of component in the picker view.
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    //Number of rows in the component.
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    //Description of the row in the component.
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    
    //Handle selection a fuel grade.
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        //Do nothing for now.
        if pickerData[row] == "electric"{
            gallonsField.placeholder = "kWatts"
        }
        else{
            gallonsField.placeholder = "Gallons"
        }
        calculateTotal()
    }
    //Override for current location.
    /*func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            let pin = mapView.view(for: annotation) as? MKMarkerAnnotationView ?? MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: nil)
            pin.markerTintColor = UIColor(.purple)
            return pin

        } else {
            // Any other annotations
        }
        return nil
    }*/
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    override func viewDidDisappear(_ animated: Bool) {
        //Update the current logged In User.
        var mainTabController = tabBarController as! mainTabBarController
        mainTabController.loggedInUser = loggedInUser
    }
    
    
    //Function: LocationnManager StartedUpdating Locations.
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else {return}

        map.setRegion(MKCoordinateRegion(center: location.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)), animated: true)
        //Show UserLocation.
        let annotation  = MKUserLocation()
        map.addAnnotation(annotation)
        map.showsUserLocation = true
        map.isHidden = false
        getAddress(coordinate: location.coordinate)
    }
    
    //Function: LocationManager failed WIth Error.
    //Failed Handler.
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        //Print the error.
        print(error.localizedDescription)
        //hide the map if can't load location.
        map.isHidden = true
    }
    
    //Function to set min date and Max date Interval .
    func setMinMaxDatePicker(){
        let calendar = Calendar(identifier: .gregorian)
        let currentDate = Date()
        var components = DateComponents()
        components.calendar = calendar
        
        //Schedule at least 1 hour in the future.
        components.hour = 1
            let minDate = calendar.date(byAdding: components, to: currentDate)!
        //Schedule at last 7 days in the future.
        components.day = 7
            let maxDate = calendar.date(byAdding: components, to: currentDate)!
        datePicker.minimumDate = minDate
        datePicker.maximumDate = maxDate
    }
    
    //Function to get the address from pinned location.
    private func getAddress(coordinate:CLLocationCoordinate2D){
        let address = CLGeocoder.init()
        address.reverseGeocodeLocation(CLLocation.init(latitude: coordinate.latitude, longitude: coordinate.longitude)) { (places, error) in
                if error == nil{
                    if let place = places{
                        //here you can get all the info by combining that you can make address
                        var addr = place[0].name ?? ""
                        addr += place[0].locality ?? ""
                        //let addr = self.parseAddress(address: place[0].description)
                        self.updateAddressLbl(address: addr)
                    }
                }
            }
    }
    
   
    
    //Function Update deliceryLabel.
    private func updateAddressLbl(address:String){
        addressLbl.text = address
    }
    
    //Process users request and get total due.
    private func calculateTotal() {
        let selectedFuel = pickerData[fuelGradePicker.selectedRow(inComponent: 0)]
        let gallonsValue = gallonsField.text!
        if !gallonsValue.isEmpty && Int(gallonsValue) != nil
            && Int(gallonsValue)!>0 &&
            Int(gallonsValue)! < 500
        {
            let fuelquantity = Int(gallonsField.text!)
        
            
            var total:Double = Double(fuelquantity!) * priceIndex[selectedFuel]!
            //round .2f
            total = round(total * 100) / 100.0
            totalLabel.text = "Total: $ \(total)"
            showTotalSubmit()
            
        }
        else{
            hideTotalSubmit()
            print("Not valid inputs just yet")
        }

    }
    
    @IBAction func finishedEnteringQuantity(_ sender: Any) {
        let selectedFuel = pickerData[fuelGradePicker.selectedRow(inComponent: 0)]
        let gallonsValue = gallonsField.text!
        if !gallonsValue.isEmpty && Int(gallonsValue) != nil
            && Int(gallonsValue)!>0 &&
            Int(gallonsValue)! < 500
        {
            let fuelquantity = Int(gallonsField.text!)
        
            
            var total:Double = Double(fuelquantity!) * priceIndex[selectedFuel]!
            //round .2f
            total = round(total * 100) / 100.0
            totalLabel.text = "Total: $ \(total)"
            showTotalSubmit()
            
        }
        else{
            hideTotalSubmit()
            print("Not valid inputs just yet")
        }
    }
    
    //Function show refill total submit button.
    private func showTotalSubmit(){
        totalLabel.isHidden = false
        submitButton.isHidden = false
        
    }
    
    //Function hide refill total submit button.
    private func hideTotalSubmit(){
        totalLabel.isHidden = true
        submitButton.isHidden = true
        
    }
}
