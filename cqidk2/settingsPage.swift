//
//  settingsPage.swift
//  cqidk2
//
//  Created by Neil Bronfin on 4/11/21.
//

import UIKit

class settingsPage: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
//All prompt function to input feedback
    @IBAction func didTapChangeEmail(_ sender: UIButton) {
        
        self.settingsAlert(title: "Enter New Email", message: "Please enter your new email address", placeHolder: "myNewEmail@gmail.com")
        
    }
    
    @IBAction func didTapSubmitFeedback(_ sender: UIButton) {
        
        self.settingsAlert(title: "Submit Feedback", message: "Any and all feedback is welcome to help improve our product", placeHolder: "I think your logo should be blue")
        
    }
    
    @IBAction func didTapReportAbuse(_ sender: UIButton) {
        
        self.settingsAlert(title: "Report Abuse", message: "Please provide specifics of the issue", placeHolder: "")
        
        
    }
    
    @IBAction func didTapOtherInquiries(_ sender: UIButton) {
    
        self.settingsAlert(title: "Other Inquiries", message: "Please describe your inquiry", placeHolder: "")
    
    }
    
    @IBAction func didTapPhotoRequest(_ sender: UIButton) {
        
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
            //Do nothing
        }

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

}
