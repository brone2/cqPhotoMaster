//
//  settingsPage.swift
//  cqidk2
//
//  Created by Neil Bronfin on 4/11/21.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseStorage
import FirebaseDatabase
import MessageUI



class settingsPage: UIViewController, MFMailComposeViewControllerDelegate {

    var buildingNameEntered:String?
    var myPastRecieve = [NSDictionary?]()
    var emailString = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
//All prompt function to input feedback
    @IBAction func didTapChangeEmail(_ sender: UIButton) {
        
        self.settingsAlert(title: "Enter New Email", message: "Please enter your new email address", placeHolder: "myNewEmail@gmail.com")
        
    }
    
    @IBAction func didTapChangeName(_ sender: UIButton) {
        
        self.settingsAlert(title: "Change Name", message: "Please enter your new name", placeHolder: "John Doe")
        
        
    }
    
    //Actually ChangeCountry
    
    @IBAction func didTapSubmitFeedback(_ sender: UIButton) {
        
        self.performSegue(withIdentifier: "settingsToChangeCountry", sender: nil)
        
    }
    
    @IBAction func didTapReportAbuse(_ sender: UIButton) {
        
        self.settingsAlert(title: "Report Abuse", message: "Please provide specifics of the issue", placeHolder: "")
        
        
    }
    
    @IBAction func didTapOtherInquiries(_ sender: UIButton) {
        
        self.updateInfo()
    
        self.settingsAlert(title: "Other Inquiries", message: "Please describe your inquiry", placeHolder: "")
    
    }
    
    override func viewDidAppear(_ animated: Bool) {
        databaseRef.child("photos").observe(.childAdded) { (snapshot2: DataSnapshot) in
              
              let snapshot2 = snapshot2.value as! NSDictionary
                print("HEEERE")
                print(snapshot2)
              let snapRecieveId = snapshot2["myId"] as? String
             // let snapComplete = snapshot2["isComplete"] as? Bool
              
              if(snapRecieveId == loggedInUserId){// && snapComplete == true){
                  self.myPastRecieve.append(snapshot2)
              }

          }
        
  
        
    }
    @IBAction func didTapPhotoRequest(_ sender: UIButton) {
            
//        databaseRef.child("photos").observe(.childAdded) { (snapshot2: DataSnapshot) in
//
//              let snapshot2 = snapshot2.value as! NSDictionary
//                print("HEEERE")
//                print(snapshot2)
//              let snapRecieveId = snapshot2["myId"] as? String
//             // let snapComplete = snapshot2["isComplete"] as? Bool
//
//              if(snapRecieveId == loggedInUserId){// && snapComplete == true){
//                  self.myPastRecieve.append(snapshot2)
//              }
//
//          }
        
        print(self.myPastRecieve)
        
        for v in self.myPastRecieve {
            let photoUrl = v!["photoUrl"] as! String
            let scannedBarcode = v!["scannedBarcode"] as! String
            let photoNote = v!["photoNote"] as! String
            let store = v!["store"] as! String
            
            print(emailString + "," + photoUrl + "-" + scannedBarcode + "-" + photoNote)
            emailString = emailString + "," + photoUrl + "-" + scannedBarcode + "-" + photoNote + "-" + store
        }
        print(emailString)
        
        
        
        //Send Email
        let composeVC = MFMailComposeViewController()
        composeVC.mailComposeDelegate = self

        // Configure the fields of the interface.
        composeVC.setToRecipients([myEmail])
        composeVC.setSubject("Photoshoot Results")
        composeVC.setMessageBody(emailString, isHTML: false)

        // Present the view controller modally.
        self.present(composeVC, animated: true, completion: nil)
        
        
        
    }
    
 

    
    
func settingsAlert (title: String, message: String, placeHolder:String) {
    var buildingNameTextField: UITextField?
    
    let alertController = UIAlertController(
        title: title,
        message: message,
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
        
        let randomNum:UInt32 = arc4random_uniform(10000)
        let someString:String = String(randomNum)
            
        let childUpdates = ["/inquiry/\(myName)/\(someString)":self.buildingNameEntered!] as [String : Any]
        databaseRef.updateChildValues(childUpdates)

    }
    
    alertController.addTextField {
        (bldName) -> Void in
        buildingNameTextField = bldName
        buildingNameTextField!.placeholder = "placeHolder"
    }
    
    alertController.addAction(cancelAction)
    alertController.addAction(completeAction)
    self.present(alertController, animated: true, completion: nil)

}
    
    
    
    
    
    func updateInfo () {
        
//    //Update Users Country all the same
//
//        databaseRef.child("users").observe(.childAdded) { (snapshot: DataSnapshot) in
//        let snapshot = snapshot.value as! NSDictionary
//        let userId = snapshot["userId"] as? String
//        let childUpdates = ["/users/\(userId!)/myCountry":"USA"]
//        databaseRef.updateChildValues(childUpdates)
//
//    //End Update Users Country all the same
            
    //Update Photo Country all the same
        
//        databaseRef.child("photos").observe(.childAdded) { (snapshot: DataSnapshot) in
//        let snapshot = snapshot.value as! NSDictionary
//        let userId = snapshot["photoKey"] as? String
//        let childUpdates = ["/photos/\(userId!)/country":"USA"]
//        databaseRef.updateChildValues(childUpdates)
            
    //End Update Photo Country all the same

// End Update Store Country all the same
        
    
            
            
            
            
            
            
//    }
        
        
        
        
        
    }
    
    
    
    
    
    
    
    
    
    
    
    

}
