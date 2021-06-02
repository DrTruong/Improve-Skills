//
//  CodeDetector.swift
//  Code Search
//
//  Created by HTB95 on 25/05/2021.
//

import UIKit
import CoreLocation

class CodeDetector {
    
    static func detectEmail(code: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        let root = emailPred.evaluate(with: code)
        if !root {
            let lowercasedCode = code.lowercased()
            if lowercasedCode.starts(with: "mailto:") || lowercasedCode.starts(with: "smtp:") {
                return true
            }
            return false
        }
        return root
    }
    
    static func detectMap(code: String) -> Bool {
        let lowercasedCode = code.lowercased()
        if lowercasedCode.starts(with: "geo:") {
            return true
        }
        return false
    }
    
    static func detectPhone(code: String) -> Bool {
        let phoneRegEx = "^0\\d{9}$"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", phoneRegEx)
        let root = phoneTest.evaluate(with: code)
        if !root {
            let lowercasedCode = code.lowercased()
            if lowercasedCode.starts(with: "tel:") {
                return true
            }
            return false
        }
        return root
    }
    
    static func detectWeb(code: String) -> Bool {
        let urlRegEx = "^(http|https|ftp)\\://([a-zA-Z0-9\\.\\-]+(\\:[a-zA-Z0-9\\.&amp;%\\$\\-]+)*@)*((25[0-5]|2[0-4][0-9]|[0-1]{1}[0-9]{2}|[1-9]{1}[0-9]{1}|[1-9])\\.(25[0-5]|2[0-4][0-9]|[0-1]{1}[0-9]{2}|[1-9]{1}[0-9]{1}|[1-9]|0)\\.(25[0-5]|2[0-4][0-9]|[0-1]{1}[0-9]{2}|[1-9]{1}[0-9]{1}|[1-9]|0)\\.(25[0-5]|2[0-4][0-9]|[0-1]{1}[0-9]{2}|[1-9]{1}[0-9]{1}|[0-9])|localhost|([a-zA-Z0-9\\-]+\\.)*[a-zA-Z0-9\\-]+\\.(com|edu|gov|int|mil|net|org|biz|arpa|info|name|pro|aero|coop|museum|[a-zA-Z]{2}))(\\:[0-9]+)*(/($|[a-zA-Z0-9\\.\\,\\?\\'\\\\\\+&amp;%\\$#\\=~_\\-]+))*$"
        let urlTest = NSPredicate(format: "SELF MATCHES %@", urlRegEx)
        let result = urlTest.evaluate(with: code)
        return result
    }
    
    static func displayOfEmail(code: String) -> String {
        if let _emailDetector = parseEmail(code) {
            return _emailDetector.address
        }
        return code
    }
    
    static func displayOfCode(_ code: String) -> String {
        if detectEmail(code: code) {
            return displayOfEmail(code: code)
        } else if detectMap(code: code) {
            return displayOfMap(code: code)
        } else if detectPhone(code: code) {
            return displayOfPhone(code: code)
        }
        return code
    }
    
    static func displayOfMap(code: String) -> String {
        if let _location = parseMap(code) {
            return "\(_location.latitude), \(_location.longitude)"
        }
        return code
    }
    
    static func displayOfPhone(code: String) -> String {
        if let _phone = parsePhone(code) {
            return _phone
        }
        return code
    }
    
    static func navigateEmail(_ string: String?) {
        if let _emailDetector = parseEmail(string) {
            if let coded = "mailto:\(_emailDetector.address)?subject=\(_emailDetector.title)&body=\(_emailDetector.text)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
                if let emailString = URL(string: coded) {
                    UIApplication.shared.open(emailString as URL)
                }
            }
        }
    }
    
    static func navigateMap(_ string: String?) {
        if let location = parseMap(string) {
            if let appleMapURL = URL(string: "maps://maps.apple.com/?q=\(location.latitude),\(location.longitude)") {
                if UIApplication.shared.canOpenURL(appleMapURL) {
                    UIApplication.shared.open(appleMapURL)
                } else {
                    navigateMapGoogle(location)
                }
            }
        }
    }
    
    static func navigateMapGoogle(_ location: CLLocationCoordinate2D) {
        if UIApplication.shared.canOpenURL(URL(string: "comgooglemaps:")!) {
            let urlString = "comgooglemaps://?ll=\(location.latitude),\(location.longitude)"
            UIApplication.shared.open(URL(string: urlString)!)
        }
        else {
            let string = "http://maps.google.com/maps?ll=\(location.latitude),\(location.longitude)"
            UIApplication.shared.open(URL(string: string)!)
        }
    }
    
    static func navigatePhone(_ string: String?) {
        if let _phone = parsePhone(string) {
            if let numberString = URL(string: "tel://\(_phone)") {
                UIApplication.shared.open(numberString as URL)
            }
        }
    }
    
    static func navigateWeb(_ string: String?) {
        if let urlString = string {
            if let url = NSURL(string: urlString){
                UIApplication.shared.open(url as URL)
            }
        }
    }
    
    static func navigateWebWithQuerry(_ string: String?) {
        if let urlString = string?
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) {
            if let url = NSURL(string: "https://google.com/search?q=\(urlString)") {
                UIApplication.shared.open(url as URL)
            }
        }
    }
    
    static func parseMap(_ string: String?) -> CLLocationCoordinate2D? {
        if let _string = string {
            if detectMap(code: _string) {
                let geoAndData = _string.split(separator: ":")
                if geoAndData.count >= 2 {
                    let data = geoAndData.last
                    let locationData = data?.split(separator: ",")
                    if locationData?.count ?? 0 >= 2 {
                        let lat = Double(locationData?.first ?? "") ?? 0
                        let long = Double(locationData?[1] ?? "") ?? 0
                        return CLLocationCoordinate2D(latitude: lat, longitude: long)
                    }
                }
            }
            return nil
        }
        return nil
    }
    
    static func parsePhone(_ string: String?) -> String? {
        if let _string = string {
            if detectPhone(code: _string) {
                let telAndData = _string.split(separator: ":")
                if telAndData.count >= 2 {
                    return String(telAndData[1])
                }
            }
            return _string
        }
        return string
    }
    
    static func parseEmail(_ string: String?) -> EmailDetector? {
        if let _string = string {
            if detectEmail(code: _string) {
                if _string.lowercased().starts(with: "mailto:") {
                    return parseEmailMAILTO(_string)
                } else if _string.lowercased().starts(with: "smtp:") {
                    return parseEmailSMTP(_string)
                }
                let emailDetector = EmailDetector()
                emailDetector.address = _string
                return emailDetector
            }
            return nil
        }
        return nil
    }
    
    static func parseEmailMAILTO(_ string: String?) -> EmailDetector? {
        if let _string = string {
            if detectEmail(code: _string) {
                let firstAndLastData = _string.split(separator: "?")
                let firstData = firstAndLastData[0].split(separator: ":")
                let lastData = firstAndLastData[1].split(separator: "&")
                let emailDetector = EmailDetector()
                if firstData.count == 2 {
                    emailDetector.address = String(firstData[1])
                }
                if lastData.count >= 1 {
                    emailDetector.title = String(lastData[0]).replacingOccurrences(of: "subject=", with: "")
                }
                if lastData.count >= 2 {
                    emailDetector.text = String(lastData[1]).replacingOccurrences(of: "body=", with: "")
                }
                return emailDetector
            }
            return nil
        }
        return nil
    }
    
    static func parseEmailSMTP(_ string: String?) -> EmailDetector? {
        if let _string = string {
            if detectEmail(code: _string) {
                let emailAndData = _string.split(separator: ":")
                let emailDetector = EmailDetector()
                if emailAndData.count == 1 {
                    emailDetector.address = String(emailAndData[0])
                }
                if emailAndData.count >= 2 {
                    emailDetector.address = String(emailAndData[1])
                }
                if emailAndData.count > 2 {
                    emailDetector.title = String(emailAndData[2])
                }
                if emailAndData.count > 3 {
                    emailDetector.text = String(emailAndData[3])
                }
                return emailDetector
            }
            return nil
        }
        return nil
    }

}

class EmailDetector {
    
    var address: String = ""
    var title: String = ""
    var text: String = ""
    
}
