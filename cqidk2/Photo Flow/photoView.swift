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
    
//
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
////        self.performSegue(withIdentifier: "photoToFinishPhoto2", sender: self)
//    }
    
    

    
  

    
  
//    let downloadUrlAbsoluteStringPath = "/request/\(runKeyPath)/productImage"
//    let downloadUrlAbsoluteStringValue = self.downloadUrlAbsoluteString
    
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    
    
//    func resize(_ image: UIImage) -> UIImage {
//        var actualHeight = Float(image.size.height)
//        var actualWidth = Float(image.size.width)
////        let maxHeight: Float = 200.0
////        let maxWidth: Float = 180.0
////        var imgRatio: Float = actualWidth / actualHeight
////        let maxRatio: Float = maxWidth / maxHeight
////        let compressionQuality: Float = 1.0
//        //50 percent compression
//        if actualHeight > maxHeight || actualWidth > maxWidth {
//            if imgRatio < maxRatio {
//                //adjust width according to maxHeight
//                imgRatio = maxHeight / actualHeight
//                actualWidth = imgRatio * actualWidth
//                actualHeight = maxHeight
//            }
//            else if imgRatio > maxRatio {
//                //adjust height according to maxWidth
//                imgRatio = maxWidth / actualWidth
//                actualHeight = imgRatio * actualHeight
//                actualWidth = maxWidth
//            }
//            else {
//                actualHeight = maxHeight
//                actualWidth = maxWidth
//            }
//        }
//        let rect = CGRect(x: 0.0, y: 0.0, width: CGFloat(actualWidth), height: CGFloat(actualHeight))
//        UIGraphicsBeginImageContext(rect.size)
//        image.draw(in: rect)
//        let img = UIGraphicsGetImageFromCurrentImageContext()
//        let imageData = UIImageJPEGRepresentation(img!, CGFloat(compressionQuality))
//        UIGraphicsEndImageContext()
//        return UIImage(data: imageData!) ?? UIImage()
//    }
    
    
}
