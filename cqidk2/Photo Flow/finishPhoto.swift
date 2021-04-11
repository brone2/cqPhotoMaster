//
//  finishPhoto.swift
//  cqidk2
//
//  Created by Neil Bronfin on 4/10/21.
//

import UIKit

class finishPhoto: UIViewController {

    
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var barcodeLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        photoViewDismissHelper = 3
        
        let image = downloadUrlAbsoluteStringValue
        let data = try? Data(contentsOf: URL(string: image)!)
        self.productImage.image = UIImage(data: data!)
        self.barcodeLabel.text = rawBarcode
        
    }
    
    @IBAction func didTapSaveDirect(_ sender: customButton) {
        
        saveItem()
        
    }
    
    @IBAction func didTapSaveAsDeliItem(_ sender: customButton) {
        
        isDeliItem = true
        saveItem()
        
    }
    
    @IBAction func didTapSaveWithNote(_ sender: customButton) {
        
        var buildingNameTextField: UITextField?
        
        let alertController = UIAlertController(
            title: "Leave Item Note",
            message: "Please add a note relating to this particular item.",
            preferredStyle: UIAlertController.Style.alert)
        
        let cancelAction = UIAlertAction(
            title: "Cancel", style: UIAlertAction.Style.default) {
            (action) -> Void in
        }
        
        let completeAction = UIAlertAction(
            title: "Complete", style: UIAlertAction.Style.default) {
            (action) -> Void in
            if let buildingName = buildingNameTextField?.text {
                photoNote = buildingName.capitalizingFirstLetter()
            }
            self.saveItem()
    }
        alertController.addTextField {
            (bldName) -> Void in
            buildingNameTextField = bldName
            buildingNameTextField!.placeholder = "This is a pack of four sodas"
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(completeAction)
        self.present(alertController, animated: true, completion: nil)

    }
    
    
    @IBAction func didTapReject(_ sender: customButton) {
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func didTapBacktoMain(_ sender: UIButton) {
        
        photoViewDismissHelper = 0
        self.dismiss(animated: true, completion: nil)
        
    }
    
  
//FUNCTION TO UPLOAD TO FIREBASE
    func saveItem() {
        
        let key = databaseRef.child("photos").childByAutoId().key!
        
        let photoUrlPath = "/photos/\(key)/photoUrl"
        let photoUrlValue = downloadUrlAbsoluteStringValue
        
        let myIdPath = "/photos/\(key)/myId"
        let myIdValue = loggedInUserId
        
        let myNamePath = "/photos/\(key)/myName"
        let myNameValue = myName
        
        let photoDatePath = "/photos/\(key)/photoDate"
        let photoDateValue = todayDate
        
        let photoStorePath = "/photos/\(key)/store"
        let photoStoreValue = myCurrentStore
        
        let photoPhotoshootKeyPath = "/photos/\(key)/photoshootKey"
        let photoPhotoshootKeyValue = myPhotoShootKey
        
        let isVariableWeightPath = "/photos/\(key)/isVariableWeight"
        let isVariableWeightValue = isVariableWeight
        
        let rawBarcodePath = "/photos/\(key)/rawBarcode"
        let rawBarcodeValue = rawBarcode
        
        let scannedBarcodePath = "/photos/\(key)/scannedBarcode"
        let scannedBarcodeValue = scannedBarcode
        
        let adjustedPluCodePath = "/photos/\(key)/adjustedPluCode"
        let adjustedPluCodeValue = adjustedPluCode
        
        let pluCodePath = "/photos/\(key)/pluCode"
        let pluCodeValue = pluCode
        
        let pluPricePath = "/photos/\(key)/pluPrice"
        let pluPriceValue = pluPrice
        
        let photoNotePath = "/photos/\(key)/photoNote"
        let photoNoteValue = photoNote
        
        let isDeliItemPath = "/photos/\(key)/isDeliItem"
        let isDeliItemValue = isDeliItem
        
        let photoTimestamp = "/photos/\(key)/timestamp"
        
        
        let childUpdates:Dictionary<String, Any> = [photoTimestamp:[".sv": "timestamp"],photoUrlPath:photoUrlValue,myIdPath:myIdValue,myNamePath:myNameValue,photoDatePath:photoDateValue,photoStorePath:photoStoreValue,photoPhotoshootKeyPath:photoPhotoshootKeyValue,isVariableWeightPath:isVariableWeightValue,rawBarcodePath:rawBarcodeValue,scannedBarcodePath:scannedBarcodeValue,adjustedPluCodePath:adjustedPluCodeValue,pluCodePath:pluCodeValue,pluPricePath:pluPriceValue,photoNotePath:photoNoteValue,isDeliItemPath:isDeliItemValue]
        
        databaseRef.updateChildValues(childUpdates)
        
//        make_alert(title: "Product Saved", message: "Content has been saved for \(scannedBarcode)")
        
//        self.dismiss(animated: false, completion: nil)
        
        let alertDeliveryComplete = UIAlertController(title: "Product Saved", message: "The content for \(rawBarcode) has been saved", preferredStyle: UIAlertController.Style.alert)
        
        alertDeliveryComplete.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
            
            self.dismiss(animated: false, completion: nil)
            
        }))
        self.present(alertDeliveryComplete, animated: true, completion: nil)

        
    }

}
