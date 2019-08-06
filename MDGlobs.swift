//
//  MDGlobs.swift
//
//  Created by Shiv on 03/05/19.
//  Copyright © 2019 MVD. All rights reserved.
//

import Foundation
import AVFoundation
import UIKit
import StoreKit

struct Platform {
    static let isSimulator: Bool = {
        #if targetEnvironment(simulator)
        return true
        #else
        return false
        #endif
    }()
}

struct Globs
{
    //App_Settings
    static var AppName              = ""
    static var store_url            = "https://itunes.apple.com/app/id"
    static var AppID                = ""
    static var BASE_URL             = ""

}

class Screen: NSObject {
    
    class func SCREEN_SIZE () -> CGSize{
        return UIScreen.main.bounds.size
    }
    
    class func SCREEN_WIDTH () -> CGFloat{
        return UIScreen.main.bounds.size.width
    }
    
    class func SCREEN_HEIGHT () -> CGFloat{
        return UIScreen.main.bounds.size.height
    }
    
    class func SCREEN_MAX_LENGTH () -> CGFloat{
        return max(Screen.SCREEN_WIDTH(), Screen.SCREEN_HEIGHT())
    }
    
    class func SCREEN_MIN_LENGTH () -> CGFloat{
        return  min(Screen.SCREEN_WIDTH(), Screen.SCREEN_HEIGHT())
    }
    
    class func WIDTHFORPER (per: CGFloat) -> CGFloat{
        return UIScreen.main.bounds.size.width * per / 100.0
    }
    
    class func HEIGHTFORPER (per: CGFloat) -> CGFloat{
        return UIScreen.main.bounds.size.height * per / 100.0
    }
    
    class func SCREEN_CENTER () -> CGPoint{
        return CGPoint(x: Screen.SCREEN_WIDTH()/2 , y: Screen.SCREEN_HEIGHT()/2 )
    }
    
    class func SCREEN_CENTER_PER ( w: CGFloat , h: CGFloat) -> CGPoint{
        return CGPoint(x: Screen.WIDTHFORPER(per: w) , y: Screen.HEIGHTFORPER(per: h))
    }
    
    class func IS_IPHONE () -> Bool{
        return UI_USER_INTERFACE_IDIOM() == .phone
    }
    
    class func IS_IPAD () -> Bool{
        return UI_USER_INTERFACE_IDIOM() == .pad
    }
    
    class func IS_IPHONE_4 () -> Bool{
        return UI_USER_INTERFACE_IDIOM() == .phone && Screen.SCREEN_MAX_LENGTH() == 480.0
    }
    
    class func IS_IPHONE_5 () -> Bool{
        return UI_USER_INTERFACE_IDIOM() == .phone && Screen.SCREEN_MAX_LENGTH() == 568.0
    }
    
    class func IS_IPHONE_6 () -> Bool{
        return UI_USER_INTERFACE_IDIOM() == .phone && Screen.SCREEN_MAX_LENGTH() == 667.0
    }
    
    class func IS_IPHONE_6P () -> Bool{
        return UI_USER_INTERFACE_IDIOM() == .phone && Screen.SCREEN_MAX_LENGTH() == 736.0
    }
    
    class func IS_IPHONE_X () -> Bool{
        return UI_USER_INTERFACE_IDIOM() == .phone && Screen.SCREEN_MAX_LENGTH() == 812.0
    }
    
    class func IS_IPHONE_Xs_Max () -> Bool{
        return UI_USER_INTERFACE_IDIOM() == .phone && Screen.SCREEN_MAX_LENGTH() == 896.0
    }
    
    class func SC_IS_HomeButton() -> Bool {
        if #available(iOS 11.0, *), let keyWindow = UIApplication.shared.keyWindow, keyWindow.safeAreaInsets.bottom > 0 { return true }
        return false
    }
    
    class func SC_BottomInsets() -> CGFloat {
        if #available(iOS 11.0, *), let keyWindow = UIApplication.shared.keyWindow{
            return keyWindow.safeAreaInsets.bottom
        }
        return 0.0
    }
    
    class func addShadow (view : UIView, shadowOpacity: Float  , shadowRadius: CGFloat){
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 0)
        view.layer.shadowOpacity = shadowOpacity
        view.layer.shadowRadius = shadowRadius
        view.layer.masksToBounds = false
    }
    
    class func showAlert(viewController: UIViewController, title: String ,message: String){
        let alertController = UIAlertController.init(title: title, message: message, preferredStyle: .alert)
        let actionOk = UIAlertAction.init(title: "Ok", style: .default)
        alertController.addAction(actionOk)
        viewController.present(alertController, animated: true, completion: nil);
    }
    
    class func UDSET(data: Any,key: String){
        UserDefaults.standard.set(data, forKey: key)
        UserDefaults.standard.synchronize()
    }
    
    class func UDValue(key: String)-> Any{
        return UserDefaults.standard.value(forKey:key) as Any;
    }
    
    class func UDValueBool(key: String)-> Bool{
        return UserDefaults.standard.value(forKey:key) as? Bool ?? false;
    }
    
    class func UDValueTrueBool(key: String)-> Bool{
        return UserDefaults.standard.value(forKey:key) as? Bool ?? true;
    }
    
    class func UIFontBlod(size: CGFloat)-> UIFont {
        return UIFont.init(name: "Montserrat-SemiBold", size: size) ?? UIFont.systemFont(ofSize: size)
    }
    
    class func getJson(objects:  [Any]?) -> Any?{
        
        if objects == nil {
            return nil
        }
        
        for objectsString in objects! {
            do {
                if let objectData = (objectsString as? String ?? "").data(using: .utf8) {
                    return try JSONSerialization.jsonObject(with: objectData, options: .mutableContainers)
                }
            }
            catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
    
    class func anyObjectJson(object:Any ,prettyPrint: Bool )->String {
        guard let data = try? JSONSerialization.data(withJSONObject: object, options: []) else {
            return "{}"
        }
        return String(data: data, encoding: String.Encoding.utf8)!
    }
    
    
    class func stringDateChangeFormat(data: String , format: String , new_format: String) -> String {
        let dateFormat =  DateFormatter()
        dateFormat.dateFormat = format;
        if let dt =  dateFormat.date(from: data) {
            dateFormat.dateFormat = new_format
            return dateFormat.string(from: dt)
        }else{
            return ""
        }
    }
    
    class func stringDateToNSDate(date: String , format: String) -> Date? {
        let dateFormat =  DateFormatter()
        dateFormat.dateFormat = format;
        return dateFormat.date(from: date)
    }
    
    class func nSDateToStringDate (date: Date , format: String) -> String? {
        let dateFormat =  DateFormatter()
        dateFormat.dateFormat = format;
        return dateFormat.string(from: date)
    }
    
    class func serverDateTimeToStringDate(date: String , format: String) -> String? {
        return self.stringDateChangeFormat(data: date, format: "yyyy-MM-dd'T'HH:mm:ss.SSSZ", new_format: format)
    }
    
    class func serverDateTimeToDate(date: String) -> Date? {
        return self.stringDateToNSDate(date: date, format: "yyyy-MM-dd'T'HH:mm:ss.SSSZ")
    }
    
    class func calAge(date: String) -> String {
        if let startDate = self.stringDateToNSDate(date: date,format: "dd-MM-yyyy") {
            let endDate = Date()
            let formatter = DateComponentsFormatter()
            formatter.unitsStyle = .full
            formatter.allowedUnits = [NSCalendar.Unit.year]
            return formatter.string(from: startDate, to: endDate) ?? ""
        }else{
            return ""
        }
    }
}

extension NSObject {
    
    #if DEBUG
    public class func Dlog(_ items: Any..., separator: String = " ", terminator: String = "\n") {
        print(items, separator: separator, terminator: terminator)
    }
    #else
    public class func Dlog(_ items: Any..., separator: String = " ", terminator: String = "\n") {
    }
    #endif
}
