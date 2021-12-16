//
//  barcodeScanner.swift
//  cqidk2
//
//  Created by Neil Bronfin on 4/10/21.
//

// Code from youtube https://docs.google.com/document/d/126OAOeagyNQROroOqcED3ux8fiBkQWDu0tP1nVYWuUo/edit?usp=sharing

//Note on this page reset all values for the photoshoot to defaults
//  TODO add note of scan to barcode
import UIKit
import AVFoundation
 
//Need to set photoViewDismissHelper = 1 here to begin next view on the camera picker
//Scan the barcode and then do all reformatting
class barcodeScanner: UIViewController {
    
    var avCaptureSession: AVCaptureSession!
    var avPreviewLayer: AVCaptureVideoPreviewLayer!
    var buildingNameEntered:String?
    
    @IBAction func didTapBackButton(_ sender: UIButton) {
        
        self.performSegue(withIdentifier: "barcodeScanToMain", sender: nil)
        
    }
    
    @IBOutlet weak var backButtonView: UIView!
    
    
    
    override func viewDidAppear(_ animated: Bool) {
     
        //Helper associated with segue from selecting Cancel on photo picker
        isTapCancelPhoto = false
        //Set all barcode values back to default
        downloadUrlAbsoluteStringValue = ""
        scannedBarcode = "TBD"
        rawBarcode = "TBD"
        isVariableWeight = false
        adjustedPluCode = ""
        pluCode = ""
        pluPrice = ""
        photoNote = ""
        isDeliItem = false
       
        
    }
 
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        downloadUrlAbsoluteStringValue = ""
        avCaptureSession = AVCaptureSession()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
     
            guard let videoCaptureDevice = AVCaptureDevice.default(for: .video)
            
            else {
                self.failed()
                return
            }
            let avVideoInput: AVCaptureDeviceInput
            
            do {
                avVideoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
            } catch {
                self.failed()
                return
            }
            
            if (self.avCaptureSession.canAddInput(avVideoInput)) {
                self.avCaptureSession.addInput(avVideoInput)
            } else {
                self.failed()
                return
            }
            
            let metadataOutput = AVCaptureMetadataOutput()
            
            if (self.avCaptureSession.canAddOutput(metadataOutput)) {
                self.avCaptureSession.addOutput(metadataOutput)
                
                metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
                metadataOutput.metadataObjectTypes = [.ean8, .ean13]
//                metadataOutput.metadataObjectTypes = [.ean8, .ean13, .pdf417, .qr] REMOVE OTHER CODES FROM BEING SCANNED
                
            } else {
                self.failed()
                return
            }
            
            self.avPreviewLayer = AVCaptureVideoPreviewLayer(session: self.avCaptureSession)
            self.avPreviewLayer.frame = self.view.layer.bounds
            self.avPreviewLayer.videoGravity = .resizeAspectFill
            self.view.layer.addSublayer(self.avPreviewLayer)
            self.view.bringSubviewToFront(self.backButtonView)
            
            //Add text to direct to scan the barcode
            let textlayer = CATextLayer()
            textlayer.frame = CGRect(x: self.view.bounds.midX - 280/2  , y: 86, width: 280, height: 44)
            textlayer.fontSize = 42
            textlayer.alignmentMode = .center
            textlayer.string = "Scan Barcode"
            textlayer.isWrapped = true
            textlayer.truncationMode = .end
            textlayer.backgroundColor = UIColor.clear.cgColor
            textlayer.foregroundColor = UIColor.green.cgColor
            self.view.layer.addSublayer(textlayer) // caLayer is and instance of parent CALayer
            //End Add text to direct to scan the barcode
            
            //Add manually enter sku button
            let myButton = UIButton(type: .system)
            myButton.frame = CGRect(x: self.view.bounds.midX - 280/2  , y: screenHeight - 140, width: 280, height: 40)
            myButton.setTitle("Enter Custom SKU", for: .normal)
            myButton.addTarget(self, action: #selector(self.buttonAction(_:)), for: .touchUpInside)
            myButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 28)
            myButton.setTitleColor(UIColor.white, for: UIControl.State.normal)
            //myButton.underlineText()
            self.view.addSubview(myButton)
            //End Add manually enter sku button
              

            self.avCaptureSession.startRunning()
        }
    }
    
//CUSTOM SKU SELECTED TO BE ENTERED
    @objc func buttonAction(_ sender:UIButton!) {

        var buildingNameTextField: UITextField?
        
        let alertController = UIAlertController(
            title: "Enter Custom SKU",
            message: "If this item has a barcode, please select Cancel and scan the barcode. Do not manually type in a barcode.",
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
                scannedBarcode = "CUSTOM - " + self.buildingNameEntered!
                rawBarcode = "CUSTOM - " + self.buildingNameEntered!
                isVariableWeight = false
                adjustedPluCode = ""
                pluCode = ""
                pluPrice = ""
            }
            
            photoViewDismissHelper = 1
            self.performSegue(withIdentifier: "barcodeScanningToTakePhoto", sender: nil)

        }
        
        alertController.addTextField {
            (bldName) -> Void in
            buildingNameTextField = bldName
            buildingNameTextField!.placeholder = "Ex: Roast Beef sold by 1/2 pound"
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(completeAction)
        self.present(alertController, animated: true, completion: nil)

      
    }
    
    
    func failed() {
        let ac = UIAlertController(title: "Scanner not supported", message: "Please use a device with a camera. Because this device does not support scanning a code", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
        avCaptureSession = nil
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if (avCaptureSession?.isRunning == false) {
            avCaptureSession.startRunning()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if (avCaptureSession?.isRunning == true) {
            avCaptureSession.stopRunning()
        }
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
}


extension barcodeScanner : AVCaptureMetadataOutputObjectsDelegate {
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {

        avCaptureSession.stopRunning()
        
        if let metadataObject = metadataObjects.first {
            guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else { return }
            guard let stringValue = readableObject.stringValue else { return }
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
            found(code: stringValue)
        }

        self.performSegue(withIdentifier: "barcodeScanningToTakePhoto", sender: nil)
    }

    
//Save and reformat barcode info. 1. Remove leading
    func found(code: String) {
        
        print(code)
        let codeAsInt = Int(code)
        let codeFormatted =  "\(codeAsInt!)"
        scannedBarcode = codeFormatted
        rawBarcode = scannedBarcode
        print(scannedBarcode)
        
        //Check if is variable weight
        let leadingDigit = scannedBarcode[0]
        if ((scannedBarcode.count) == 12) && (leadingDigit == "2") {
            isVariableWeight = true
            adjustedPluCode = "a" + scannedBarcode.substring(toIndex: scannedBarcode.length - 5) + "00000"
            pluCode = "a" + scannedBarcode[1 ..< 6]
            pluPrice = "a" + scannedBarcode[7 ..< 11]
        } else {
            isVariableWeight = false
            adjustedPluCode = ""
            pluCode = ""
            pluPrice = ""
        }
        scannedBarcode = "a" + scannedBarcode
        
        //IN AUDIT HERE DO THE CHECK IF THE PRODUCT IS IN CATALOG
        
        
        
        print(scannedBarcode)
        print(isVariableWeight)
        print(adjustedPluCode)
        print(pluCode)
        print(pluPrice)
        photoViewDismissHelper = 1
    }
}




extension String {

    var length: Int {
        return count
    }

    subscript (i: Int) -> String {
        return self[i ..< i + 1]
    }

    func substring(fromIndex: Int) -> String {
        return self[min(fromIndex, length) ..< length]
    }

    func substring(toIndex: Int) -> String {
        return self[0 ..< max(0, toIndex)]
    }

    subscript (r: Range<Int>) -> String {
        let range = Range(uncheckedBounds: (lower: max(0, min(length, r.lowerBound)),
                                            upper: min(length, max(0, r.upperBound))))
        let start = index(startIndex, offsetBy: range.lowerBound)
        let end = index(start, offsetBy: range.upperBound - range.lowerBound)
        return String(self[start ..< end])
    }
}


extension UIButton {
  func underlineText() {
    guard let title = title(for: .normal) else { return }

    let titleString = NSMutableAttributedString(string: title)
    titleString.addAttribute(
      .underlineStyle,
      value: NSUnderlineStyle.single.rawValue,
      range: NSRange(location: 0, length: title.count)
    )
    setAttributedTitle(titleString, for: .normal)
  }
}
