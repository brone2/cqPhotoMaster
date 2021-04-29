//
//  photoView.swift
//  cqidk2
//
//  Created by Neil Bronfin on 4/10/21.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseStorage
import FirebaseDatabase
import FBSDKLoginKit

class photoView: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

//    https://stackoverflow.com/questions/28419336/uiimagepickercontroller-camera-overlay-that-matches-the-default-cropping
    var storageRef = Storage.storage().reference()
    
    override func viewDidLoad() {
        super.viewDidLoad()

      
    }
    override func viewDidAppear(_ animated: Bool) { 

        print(photoViewDismissHelper)
        if photoViewDismissHelper == 1 {
        let picker = UIImagePickerController()
        picker.sourceType = .camera
        picker.delegate = self
        picker.allowsEditing = true

//THIS IS FOR CAMERA OVERLAY
        picker.cameraOverlayView = guideForCameraOverlay()
        picker.view.layer.addObserver(self, forKeyPath: "bounds", options: .new, context: nil)
//END THIS IS FOR CAMERA OVERLAY
        
        self.present(picker, animated: true)
            
        }
        
        if photoViewDismissHelper == 2 {
            print(photoViewDismissHelper)
            self.dismiss(animated: false, completion: nil)
        }
    }
    
  
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        photoViewDismissHelper = 2

        guard let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else {
            return
        }
        
        guard let imageData = image.pngData() else {
            return
        }
        
        let key = databaseRef.child("photos").childByAutoId().key
        
        storageRef.child("photos/\(key)/file.png").putData(imageData, metadata: nil) { (_, error) in
            guard error == nil else {
                print("failed to upload")
                return
            }
            
            self.storageRef.child("photos/\(key)/file.png").downloadURL(completion: {url,error in guard let url = url, error == nil else {
                return
            }
           
            downloadUrlAbsoluteStringValue = url.absoluteString
            print(downloadUrlAbsoluteStringValue)
            self.dismiss(animated: false, completion: nil)
            
            })
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    
    
    

////THIS IS FOR CAMERA OVERLAY
    func guideForCameraOverlay() -> UIView {
        let guide = UIView(frame: UIScreen.main.fullScreenSquare())
        guide.backgroundColor = UIColor.clear
        guide.layer.borderWidth = 20
        guide.layer.borderColor = UIColor.green.cgColor
        guide.isUserInteractionEnabled = false
        return guide
    }
//    //END THIS IS FOR CAMERA OVERLAY
    
}

////THIS IS FOR CAMERA OVERLAY

extension UIScreen {
    func fullScreenSquare() -> CGRect {
        var hw:CGFloat = 0
        var isLandscape = false
        if UIScreen.main.bounds.size.width < UIScreen.main.bounds.size.height {
        hw = UIScreen.main.bounds.size.width
    }
    else {
        isLandscape = true
        hw = UIScreen.main.bounds.size.height
    }

    var x:CGFloat = 0
    var y:CGFloat = 0

        if isLandscape {
            x = (UIScreen.main.bounds.size.width / 2) - (hw / 2)
        } else {
        
        let window = UIApplication.shared.windows[0]
        let topPadding = window.safeAreaInsets.top
        let bottomPadding = window.safeAreaInsets.bottom
        let padding_height = topPadding + bottomPadding
            
        y = (UIScreen.main.bounds.size.height / 2) - (hw / 2) //Original

//            #Not working iPhone8 Plus
            
//PHONE SIZES ADJUST Y *********************
            
        if isX && screenHeight >= 667.0 { //VALIDATED iPhoneX, iPhone11 Pro
                    
            y = ((UIScreen.main.bounds.size.height - padding_height - 28 + 12) / 2) - (hw / 2)
                    
        }
            
        if isX && screenHeight >= 736.0 { //VALIDATED iPhoneX, iPhone11 Pro
                
            y = ((UIScreen.main.bounds.size.height - padding_height - 28 + 8) / 2) - (hw / 2)
                
        }
            
        if isX && screenHeight >= 812.0 { //VALIDATED iPhoneX, iPhone11 Pro
            
            y = ((UIScreen.main.bounds.size.height - padding_height - 28) / 2) - (hw / 2)
            
        }
            
        if isX && screenHeight >= 844.0 { //NOT VALIDATED**** iPhone12, iPhone12 Pro
                        
            let size_adjust = (844 - 812)/2 //=16
            y = ((UIScreen.main.bounds.size.height - padding_height - 28 - 16 / 2) - (hw / 2))
                        
        }
           
        if isX && screenHeight >= 896.0 { //NOT VALIDATED**** iPhone11, iPhone11 ProMax,
                
            let size_adjust = (896 - 812)/2 //=42
            y = ((UIScreen.main.bounds.size.height - padding_height - 28 - 42 / 2) - (hw / 2))
                
        }
            
        if isX && screenHeight >= 926.0 { //NOT VALIDATED**** iPhone12 ProMax,
                    
            let size_adjust = (926 - 812)/2 //=57
            y = ((UIScreen.main.bounds.size.height - padding_height - 28 - 57 / 2) - (hw / 2))
                    
        }
                
            
     
            

    }
        return CGRect(x: x, y: y, width: hw, height: hw)
    }
    func isLandscape() -> Bool {
        return UIScreen.main.bounds.size.width > UIScreen.main.bounds.size.height
    }
}

////END THIS IS FOR CAMERA OVERLAY
