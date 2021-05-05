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
 
//Scan the barcode and then do all reformatting
class barcodeScanner: UIViewController {
    
    var avCaptureSession: AVCaptureSession!
    var avPreviewLayer: AVCaptureVideoPreviewLayer!
    
    
    override func viewDidAppear(_ animated: Bool) {
     
        //Add text on top of barcode scann begin*********
        
        let textlayer = CATextLayer()

        textlayer.frame = CGRect(x: view.bounds.midX - 280/2  , y: 80, width: 280, height: 40)
        textlayer.fontSize = 40
        textlayer.alignmentMode = .center
        textlayer.string = "Scan Barcode"
        textlayer.isWrapped = true
        textlayer.truncationMode = .end
        textlayer.backgroundColor = UIColor.clear.cgColor
        textlayer.foregroundColor = UIColor.green.cgColor

        view.layer.addSublayer(textlayer) // caLayer is and instance of parent CALayer
        
        //text on top of barcode scann end*********
 
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
        
        if photoViewDismissHelper == 1 {
            //        PUT THIS BACK
//            self.performSegue(withIdentifier: "barcodeScannerToFinalPhoto", sender: nil)
        }
        
        
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
            self.avCaptureSession.startRunning()
        }
    }
    
    
    func failed() {
        let ac = UIAlertController(title: "Scanner not supported", message: "Please use a device with a camera. Because this device does not support scanning a code", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
        avCaptureSession = nil
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if photoViewDismissHelper == 1 {
         
            //        PUT THIS BACK
//            self.dismiss(animated: false, completion: nil)
        }
        
        
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
        
        
        
        //        PUT THIS BACK
//        dismiss(animated: true)
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
        
        print(scannedBarcode)
        print(isVariableWeight)
        print(adjustedPluCode)
        print(pluCode)
        print(pluPrice)
        
//        self.performSegue(withIdentifier: "barcodeScanningToTakePhoto", sender: nil)
        photoViewDismissHelper = 1
        
//        PUT THIS BACK
//        self.dismiss(animated: false, completion: nil)

        
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
