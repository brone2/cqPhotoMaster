//
//  mainPage.swift
//  cqidk2
//
//  Created by Neil Bronfin on 4/9/21.
//

import UIKit

class mainPage: UIViewController {

    @IBOutlet weak var myCurrentStoreLabel: UILabel!
    @IBOutlet weak var photoShootIdLabel: UILabel!
    
    
    override func viewDidAppear(_ animated: Bool) {
        print("APPPEAR")
        self.myCurrentStoreLabel.text = myCurrentStore
        self.photoShootIdLabel.text = myPhotoShootKey
        
        print(photoViewDismissHelper)
        
        if photoViewDismissHelper == 1 {
            self.performSegue(withIdentifier: "mainToPhotoView", sender: nil)
        }
        
        if photoViewDismissHelper == 2 {
            self.performSegue(withIdentifier: "mainTofinalPhoto", sender: nil)
        }
        
        if photoViewDismissHelper == 3 {
            self.performSegue(withIdentifier: "mainToBarcodeScan", sender: nil)
        }
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        print("hello")
    }
    
    @IBAction func didTapBeginPhotoshoot(_ sender: UIButton) {
        
        //Create the photoshoot, with id, date, store, photographer name
        //Create key let randomNum:UInt32 = arc4random_uniform(1000)
        let randomNum:UInt32 = arc4random_uniform(100)
        let someString:String = String(randomNum)
        let photoshootKey = myCurrentStore + "-" + someString
        myPhotoShootKey = photoshootKey
        
        make_alert(title: "Begin Photoshoot", message: "Please remember to connect to wifi before taking photos. Your photoshoot id is \(myPhotoShootKey)")
        let childUpdates = ["/photoshoots/\(photoshootKey)/photoshootKey":myPhotoShootKey,"/photoshoots/\(photoshootKey)/store":myCurrentStore,"/photoshoots/\(photoshootKey)/photographer":myName,"/photoshoots/\(photoshootKey)/startDate":todayDate,"/photoshoots/\(photoshootKey)/myId":loggedInUserId,"/photoshoots/\(photoshootKey)/startTimestamp":[".sv": "timestamp"]] as [String : Any]
        
        databaseRef.updateChildValues(childUpdates)
        self.photoShootIdLabel.text = myPhotoShootKey

        
    }
    
    
    @IBAction func didTapStartPhotos(_ sender: UIButton) {
        
        performSegue(withIdentifier: "mainToBarcodeScan", sender: nil)
        
    }
    
    @IBAction func didTapContinuePhotoshoot(_ sender: UIButton) {
        
        
        
        
        
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
