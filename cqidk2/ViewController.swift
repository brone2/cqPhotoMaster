//
//  ViewController.swift
//  cqidk2
//
//  Created by Neil Bronfin on 4/7/21.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseStorage
import FirebaseDatabase
import FBSDKLoginKit

var autoLoginHelp: Int = 0

//General User info
var myCurrentStore:String = "notSelected"
var myCountry:String = "notSelected"
var todayDate:String = String(Date.getCurrentDate())
var myName:String = "TBD"
var loggedInUserId:String = "TBD"
var databaseRef = Database.database().reference()
var loggedInUserEmail:String = "TBD"
var myPhotoShootKey:String = "TBD"
var myEmail:String = "TBD"
var isX = true
var screenHeight:CGFloat = 25.0


//Scanning barcode variables
var scannedBarcode:String = "TBD"
var rawBarcode:String = "TBD"
var isVariableWeight:Bool = false
var adjustedPluCode:String = "FALSE"
var pluCode:String = "FALSE"
var pluPrice:String = "0.00"
var photoNote:String = ""
var isDeliItem:Bool = false

//Uploading Photo variables
var downloadUrlAbsoluteStringPath:String = "TBD"
var downloadUrlAbsoluteStringValue = "TBD"

//segue helpers
var photoViewDismissHelper = 0
var isTapCancelPhoto:Bool = false

var is_iphone_12:Bool = false

class ViewController: UIViewController {

    var time = 0
    var timer = Timer()
    var loggedInUserData: AnyObject?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        try! Auth.auth().signOut()
        
        self.checkModel()
        self.detectIphone()
        
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(ViewController.startTimer), userInfo: nil, repeats: true)
        
        print("Hello big dog!")
    }
    
    func checkModel()  {
        var systemInfo = utsname()
        uname(&systemInfo)
        let modelCode = withUnsafePointer(to: &systemInfo.machine) {
            $0.withMemoryRebound(to: CChar.self, capacity: 1) {
                ptr in String.init(validatingUTF8: ptr)
            }
        }
        
        if modelCode != nil {
            if modelCode!.contains("iPhone12") {
                is_iphone_12 = true
            }
        }
        print(modelCode)
    }
    
    @objc func startTimer() {
        time += 1
        if time == 1 {
            //timer.invalidate()
            self.checkUser()
        }
        
        if time == 5 {
            print("gotto5")
            timer.invalidate()
            self.performSegue(withIdentifier: "introtoLogin", sender: nil)
        }
        
    }
    
    
    func checkUser()  {
        
        Auth.auth().addStateDidChangeListener({ (auth, user) in
            
            if autoLoginHelp == 0 {
                
        print(user)
     
            if user != nil {
                
                self.timer.invalidate()
                loggedInUserId = Auth.auth().currentUser!.uid
                
                //get user name
                databaseRef.child("users").child(loggedInUserId).observeSingleEvent(of: .value) { (snapshot:DataSnapshot) in
                    self.loggedInUserData = snapshot.value as? NSDictionary
                    
                    if self.loggedInUserData?["myName"] as? String == nil  {
                        try! Auth.auth().signOut()
                        self.timer.invalidate()
                        self.performSegue(withIdentifier: "introtoLogin", sender: nil)
                        
                    } else {
                        
                        myName = (self.loggedInUserData?["myName"] as? String)!
                        myEmail = (self.loggedInUserData?["myEmail"] as? String)!
                        
                        if self.loggedInUserData?["myCountry"] as? String == nil  {
                            
                            myCountry = "USA"
                            
                        } else {
                            
                            myCountry = (self.loggedInUserData?["myCountry"] as? String)!
                            
                        }
                        self.performSegue(withIdentifier: "introToStore", sender: nil)
                    }
                } // end get uder info
            }
            
            }
        }) //Auth.auth()?.addStateDidChangeListener({ (auth, user) in
    }
    
   
    
    func detectIphone() {
        let screenSize: CGRect = UIScreen.main.bounds
        
        screenHeight = screenSize.height
        print(screenHeight)
        
        if UIDevice().userInterfaceIdiom == .phone && UIScreen.main.nativeBounds.height == 2436
      // || UIApplication.shared.delegate?.window??.safeAreaInsets.top ?? 0 > 24
        {
            isX = true
            print("isX!")
        }
        
        if #available(iOS 11.0, *) {
            if UIApplication.shared.delegate?.window??.safeAreaInsets.top ?? 0 > 24 {
                isX = true
                print("isX!")
            }
        }
    }

        
}

extension Date {

 static func getCurrentDate() -> String {

        let dateFormatter = DateFormatter()

        dateFormatter.dateFormat = "dd/MM/yyyy HH:mm:ss"

        return dateFormatter.string(from: Date())

    }
}



