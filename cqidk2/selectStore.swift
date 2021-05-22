//
//  selectStore.swift
//  cqidk2
//
//  Created by Neil Bronfin on 4/9/21.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage

var yTestValue:CGFloat = 50.0

class selectStore: UIViewController,UITableViewDelegate,UITableViewDataSource  {
    
//    var friend_array = ["Galson","barack","mo","Kim"]
    
    var buildingsNearMe = [NSDictionary?]()
    
    var buildingNameEntered:String?
    
    var yTestHelper: AnyObject?
    
    override func viewDidAppear(_ animated: Bool) {
        
        
        //TEST GET Y COORDINATES FOR BOX ON IPHONE 12 *******************
        databaseRef.child("inquiry").child("ytest").observeSingleEvent(of: .value) { (snapshot:DataSnapshot) in
            self.yTestHelper = snapshot.value as? NSDictionary
            if self.yTestHelper?["yTestValue"] != nil  {
                yTestValue = (self.yTestHelper!["yTestValue"] as? CGFloat)!
                print(yTestValue)
            }
        } // end get uder info
        // END TEST GET Y COORDINATES FOR BOX ON IPHONE 12 *******************
        
        if myCountry == "notSelected" {
            myCountry = "USA"
            print(myName)
        }
        
        if isX == false{
                for constraint in self.view.constraints {
                    if constraint.identifier == "toolBarConstraint" {
                        constraint.constant = 0
                    }
                }  
        }
        
            databaseRef.child("store").observe(.childAdded) { (snapshot: DataSnapshot) in
            
            let snapshot = snapshot.value as! NSDictionary
                
            //Filter on country
            let country = snapshot["country"] as? String
            print(country)
            print(myCountry)
                
        if country == myCountry {
                
            let requestDict = snapshot as! NSMutableDictionary
                
            self.buildingsNearMe.append(requestDict)
            
            self.buildingsNearMe.sort{($0?["store"] as! String) < ($1?["store"] as! String) }
            
                print(self.buildingsNearMe)
            
            self.storeTable.reloadData()
        }
            
        }
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    //This method says how many rows will be in your table
        public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

            return self.buildingsNearMe.count
            
        }
       
    //This method will provide context for each cell
        public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
    //define the cell as type cell to return
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
            
            cell.textLabel?.text = self.buildingsNearMe[indexPath.row]?["store"] as? String
            
            return cell
   
            
        }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
        let selectedRowIndex = indexPath.row
        
        myCurrentStore = self.buildingsNearMe[indexPath.row]?["store"] as! String
        
        print(myCurrentStore)
        
        self.performSegue(withIdentifier: "selectStoreToMain", sender: nil)
    }

    
    @IBOutlet weak var storeTable: UITableView!
    
    @IBAction func didTapAddNewStore(_ sender: UIBarButtonItem) {
        
        var buildingNameTextField: UITextField?
        
        let alertController = UIAlertController(
            title: "Add New Store",
            message: "Please add the name of the store you are taking photos for.",
            preferredStyle: UIAlertController.Style.alert)
        
        let cancelAction = UIAlertAction(
            title: "Cancel", style: UIAlertAction.Style.default) {
            (action) -> Void in
        }
        
        let completeAction = UIAlertAction(
            title: "Complete", style: UIAlertAction.Style.default) {
            (action) -> Void in
            if let buildingName = buildingNameTextField?.text {
                self.buildingNameEntered = buildingName.capitalizingFirstLetter()
            }
            
            myCurrentStore = self.buildingNameEntered!
            let key = databaseRef.child("store").childByAutoId().key!
            
            let childUpdates = ["/store/\(key)/store":self.buildingNameEntered!,"/store/\(key)/created_by_uid":loggedInUserId, "/store/\(key)/created_by_name":myName,"/store/\(key)/created_date":todayDate,"/store/\(key)/country":myCountry,"/store/\(key)/storeKey":key] as [String : Any]
            
            print(childUpdates)
            
            databaseRef.updateChildValues(childUpdates)
            
            self.segueOn()
 
        }
        
        alertController.addTextField {
            (bldName) -> Void in
            buildingNameTextField = bldName
            buildingNameTextField!.placeholder = "The Corner Market"
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(completeAction)
        self.present(alertController, animated: true, completion: nil)

    }
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
     // Pass the selected obje@objc ct to the new view controller.
    }
    */
    func segueOn() {
        
        print("NOTCED")
        let alert = UIAlertController(title: "Store Registered", message:  "Welcome to \(self.buildingNameEntered!)!", preferredStyle: UIAlertController.Style.alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
                
                print(myCurrentStore)
                
                self.performSegue(withIdentifier: "selectStoreToMain", sender: nil)
            }))
        present(alert, animated: true, completion: nil)
    }
    
    func toolBarReformat(){
        
        for constraint in self.view.constraints {
            if constraint.identifier == "toolBarConstraint" {
                constraint.constant = 0
            }
            
        }
        
    }
    

}


extension UIViewController {
    func make_alert(title: String,message: String){
        
    let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
            //what happens when button is clicked
//            self.dismiss(animated: true, completion: nil)
        }))
        
        present(alert, animated: true, completion: nil)
 
    }//func make_alert(title: String,message: String){
}


extension String {
    func capitalizingFirstLetter() -> String {
        return prefix(1).capitalized + dropFirst()
    }

    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
}
