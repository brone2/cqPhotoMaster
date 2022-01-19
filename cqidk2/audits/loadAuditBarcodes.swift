//
//  loadAuditBarcodes.swift
//  cqidk2
//
//  Created by Neil Bronfin on 1/13/22.
//

import UIKit
import Foundation

//Metabase query https://metabase.internal.cornershop.io/question/30573-audit-query-help-1

class loadAuditBarcodes: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    func gather_have_content_barcodes (){
        
        let have_content_integration_url = URL(string: "https://sheet.best/api/sheets/4b104909-e4e6-4bbb-b375-c0df2b7e1f61")!

        let task = URLSession.shared.dataTask(with: have_content_integration_url) {(data, response, error) in
            guard let data = data else { return }
            let data2 = String(data: data, encoding: .utf8)!
            let split_data2 = data2.components(separatedBy: ",")
            for str in split_data2 {
                if let frontIndex = str.endIndex(of: "a") { // get after that character is found
                    if let backIndex = str.index(of: "}") {
                        let subString = str[frontIndex..<backIndex]
                        let upcValue = subString.replacingOccurrences(of: "\"", with: "")
                        let upcValueInt = Int(upcValue)
                        let upcValueString = "a\(upcValueInt!)"
                        auditHaveContentBarcodes.append(upcValueString)
//                        print(auditHaveContentBarcodes)
                    } //if let frontIndex = str.index(of: ":") {
                } //let frontIndex = str.index(of: ":") {
            }
        }
        task.resume()
    }
    
    func gather_missing_photos_barcodes (){
        
        let missing_photo_url = URL(string: "https://sheet.best/api/sheets/d0ff3700-cb6b-44c0-8e01-69301bc4ffbc")!

        let task = URLSession.shared.dataTask(with: missing_photo_url) {(data, response, error) in
            guard let data = data else { return }
            let data2 = String(data: data, encoding: .utf8)!
            let split_data2 = data2.components(separatedBy: ",")
            for str in split_data2 {
                if let frontIndex = str.endIndex(of: "a") { // get after that character is found
                    if let backIndex = str.index(of: "}") {
                        let subString = str[frontIndex..<backIndex]
                        let upcValue = subString.replacingOccurrences(of: "\"", with: "")
                        let upcValueInt = Int(upcValue)
                        let upcValueString = "a\(upcValueInt!)"
                        auditMissingPhotoBarcodes.append(upcValueString)
//                        print(auditMissingPhotoBarcodes)
                    } //if let frontIndex = str.index(of: ":") {
                } //let frontIndex = str.index(of: ":") {
            }
        }
        task.resume()
    }
}


extension StringProtocol {
    func index<S: StringProtocol>(of string: S, options: String.CompareOptions = []) -> Index? {
        range(of: string, options: options)?.lowerBound
    }
    func endIndex<S: StringProtocol>(of string: S, options: String.CompareOptions = []) -> Index? {
        range(of: string, options: options)?.upperBound
    }
    func indices<S: StringProtocol>(of string: S, options: String.CompareOptions = []) -> [Index] {
        ranges(of: string, options: options).map(\.lowerBound)
    }
    func ranges<S: StringProtocol>(of string: S, options: String.CompareOptions = []) -> [Range<Index>] {
        var result: [Range<Index>] = []
        var startIndex = self.startIndex
        while startIndex < endIndex,
            let range = self[startIndex...]
                .range(of: string, options: options) {
                result.append(range)
                startIndex = range.lowerBound < range.upperBound ? range.upperBound :
                    index(range.lowerBound, offsetBy: 1, limitedBy: endIndex) ?? endIndex
        }
        return result
    }
}
