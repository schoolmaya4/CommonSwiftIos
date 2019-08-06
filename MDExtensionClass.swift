//
//  MDExtensionClass.swift
//
//  Created by Shiv on 03/05/19.
//  Copyright © 2019 MVD. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation
import SDWebImage
import JTProgressHUD
import CoreMedia
import AGHandyUIKit


extension String
{
    func isValidEmail() -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: self)
    }
    
    func height(constraintedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let label =  UILabel(frame: CGRect(x: 0, y: 0, width: width, height: .greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.text = self
        label.font = font
        label.sizeToFit()
        return label.frame.height
    }
    
    var htmlToAttributedString: NSAttributedString? {
        guard let data = data(using: .utf8) else { return NSAttributedString() }
        do {
            return try NSAttributedString(data: data, options: [NSAttributedString.DocumentReadingOptionKey.documentType:  NSAttributedString.DocumentType.html], documentAttributes: nil)
        } catch {
            return NSAttributedString()
        }
    }
    
    var htmlToString: String {
        return htmlToAttributedString?.string ?? ""
    }
    
    var nowDateToString: String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMM_ddhhmmsss"
        let date = dateFormatter.string(from: Date())
        return date
    }
    
    var nowDateYYYYMMDDToString: String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd_hh_mm_ss_a"
        let date = dateFormatter.string(from: Date())
        return date
    }
    
    var stringToDate: Date{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd hh:mm:ss"
        let date = dateFormatter.date(from: self)
        return (date == nil) ? Date() : date!
    }
    
    var fileName:String {
        return NSURL(fileURLWithPath: self).deletingPathExtension?.lastPathComponent ?? ""
    }
    
    var fileExtension:String {
        return NSURL(fileURLWithPath: self).pathExtension ?? ""
    }
    
    var toURL:URL
    {
        let urlString = self.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
        return URL.init(string: urlString!)!
    }
    
    var videoDuration: String {
        let totalSeconds = CMTimeGetSeconds(AVAsset(url: URL(fileURLWithPath: self)).duration)
        let hours:Int = Int(totalSeconds / 3600)
        let minutes:Int = Int(totalSeconds.truncatingRemainder(dividingBy: 3600) / 60)
        let seconds:Int = Int(totalSeconds.truncatingRemainder(dividingBy: 60))
        if hours > 0 {
            return String(format: "%i:%02i:%02i", hours, minutes, seconds)
        } else {
            return String(format: "%02i:%02i", minutes, seconds)
        }
    }
    
    func replaceFirstOccurrence(of: String, with newString: String) -> String {
        var temp: String = self
        if let range = self.range(of:of) {
            temp.replaceSubrange(range, with: newString)
        }
        return temp
    }
    
    func base64ToString() -> String {
        if self == "" {
            return ""
        }
        return String(data: Data(base64Encoded: self)!, encoding: .utf8)!
    }
    
    func stringDateChangeFormat(format: String , new_format: String) -> String {
        let dateFormat =  DateFormatter()
        dateFormat.dateFormat = format;
        if let dt =  dateFormat.date(from: self) {
            dateFormat.dateFormat = new_format
            return dateFormat.string(from: dt)
        }else{
            return ""
        }
    }
    
    func stringDateToNSDate(format: String) -> Date? {
        let dateFormat =  DateFormatter()
        dateFormat.dateFormat = format;
        return dateFormat.date(from: self)
    }
    
    func nSDateToStringDate (date: Date , format: String) -> String {
        let dateFormat =  DateFormatter()
        dateFormat.dateFormat = format;
        return dateFormat.string(from: date)
    }
    
    func serverDateTimeToStringDate(format: String) -> String {
        return self.stringDateChangeFormat(format: "yyyy-MM-dd HH:mm:ss", new_format: format)
    }
    
    func serverDateTimeToDate(date: String) -> Date? {
        return self.stringDateToNSDate(format: "yyyy-MM-dd HH:mm:ss")
    }
    
    
    func serverDateTimeToTodayFormat( isShort: Bool = true ) -> String {
        if let serverDate = self.serverDateTimeToDate(date: self) {
            if Calendar.current.isDateInToday(serverDate) {
                return self.nSDateToStringDate(date: serverDate, format: "hh:mm a")
            }else if Calendar.current.isDateInYesterday(serverDate ) {
                return  isShort ? "Yesterday" : self.nSDateToStringDate(date: serverDate, format: "'Yesterday' hh:mm a")
            }else if Calendar.current.dateComponents([.day], from: serverDate, to: Date()).day ?? 0 < 7{
                return self.nSDateToStringDate(date: serverDate, format: isShort ? "EEEE" : "EEEE hh:mm a")
            }else{
                return self.nSDateToStringDate(date: serverDate, format: isShort ? "dd/MM/yy" : "dd/MM/yy hh:mm a")
            }
        }else{
            return "-"
        }
    }
}

extension Date
{
    // Convert local time to UTC (or GMT)
    public func toGlobalTime() -> Date {
        let timezone = TimeZone.current
        let seconds = -TimeInterval(timezone.secondsFromGMT(for: self))
        return Date(timeInterval: seconds, since: self)
    }
    
    // Convert UTC (or GMT) to local time
    public func toLocalTime() -> Date {
        let timezone = TimeZone.current
        let seconds = TimeInterval(timezone.secondsFromGMT(for: self))
        return Date(timeInterval: seconds, since: self)
    }
    
    var dateFormatterString: String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM dd, yyyy hh:mm:ss a"
        let date = dateFormatter.string(from: self)
        return date
    }
    
    var dateYearString: String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy"
        let date = dateFormatter.string(from: self)
        return date
    }
    
    var timestampString: String?
    {
        var calendar = Calendar.current
        calendar.locale = Locale(identifier: "en_US_POSIX")
        calendar.timeZone = TimeZone.current
        
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .full
        formatter.maximumUnitCount = 1
        formatter.allowedUnits = [.year, .month, .day, .hour, .minute, .second]
        formatter.calendar = calendar
        
        guard let timeString = formatter.string(from: self, to: Date()) else {
            return nil
        }
        
        let formatString = NSLocalizedString("%@", comment: "")
        return String(format: formatString, timeString)
    }
}

extension UIImageView
{
    func downloadedFrom(url: URL, contentMode mode: UIView.ContentMode = .scaleAspectFit) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() {
                self.image = image
            }
            }.resume()
    }
    
    func downloadedFrom(link: String, contentMode mode: UIView.ContentMode = .scaleAspectFit) {
        guard let url = URL(string: link) else { return }
        downloadedFrom(url: url, contentMode: mode)
    }
    
    func loadImage(urlString: String?, placeHolder: String? ) {
        let url = String.init(format: "%@", urlString ?? "" )
        
        if placeHolder != nil && placeHolder != "" {
            
            if url.hasPrefix("http") {
                self.sd_imageIndicator = SDWebImageActivityIndicator.gray
                self.sd_setImage(with: URL(string: url), placeholderImage: UIImage(named: placeHolder ?? "") , completed: nil)
            }else{
                self.image = UIImage(named: placeHolder ?? "")
            }

        }else{
            self.sd_imageIndicator = SDWebImageActivityIndicator.gray
            self.sd_setImage(with: URL(string: url))
        }
    }
    
    override open func awakeFromNib() {
        super.awakeFromNib()
        tintColorDidChange()
    }
}

extension UIView
{
    func dropShadow(color: UIColor, opacity: Float = 0.5, offSet: CGSize, radius: CGFloat = 1, scale: Bool = true) {
        self.layer.masksToBounds = false
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOpacity = opacity
        self.layer.shadowOffset = offSet
        self.layer.shadowRadius = radius
        self.layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
    
    var App_Delegate:AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }
}



@objc enum ButtonAnimationType: UInt {
    case none = 0, self_press, super_press
}


extension UIControl {
    
    @objc @IBInspectable var pressAnimation: Int  {
        get {
            guard let value = objc_getAssociatedObject(self, &AssociatedKeys.btnAnimation) as? Int else {
                return 0
            }
            return value
        }
        set {
            self.addTarget(self, action: #selector(btnPressAnimationPlay), for: .touchDown)
            self.addTarget(self, action: #selector(btnPressUpAnimationPlay), for: .touchUpInside)
            objc_setAssociatedObject(self, &AssociatedKeys.btnAnimation, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    
    @objc private func btnPressAnimationPlay(){
        
        switch self.pressAnimation {
        case 1:
            self.shadowColor = self.shadowColor.withAlphaComponent(0)
            break
        case 2:
            self.superview?.shadowColor = self.superview?.shadowColor.withAlphaComponent(0)
            
            break
        default:
            break
        }
        //        print("Press Animation")
    }
    
    @objc private func btnPressUpAnimationPlay(){
        switch self.pressAnimation {
        case 1:
            self.shadowColor = self.shadowColor.withAlphaComponent(1)
            break
        case 2:
            self.superview?.shadowColor = self.superview?.shadowColor.withAlphaComponent(1)
            break
        default:
            break
        }
        //         print("Press Up Animation")
    }
    
}


extension URL {
    var videoThumbNail: UIImage? {
        do {
            let generate1 = AVAssetImageGenerator.init(asset: AVURLAsset.init(url: self))
            generate1.appliesPreferredTrackTransform = true
            let oneRef = try generate1.copyCGImage(at: CMTime(seconds: 1, preferredTimescale: 2), actualTime: nil)
            return UIImage(cgImage: oneRef)
        }
        catch {
            print(" videoThumbNail Error: %@", error.localizedDescription)
            return nil
        }
    }
    
    var videoDuration: String {
        let totalSeconds = CMTimeGetSeconds(AVAsset(url: self).duration)
        let hours:Int = Int(totalSeconds / 3600)
        let minutes:Int = Int(totalSeconds.truncatingRemainder(dividingBy: 3600) / 60)
        let seconds:Int = Int(totalSeconds.truncatingRemainder(dividingBy: 60))
        if hours > 0 {
            return String(format: "%i:%02i:%02i", hours, minutes, seconds)
        } else {
            return String(format: "%02i:%02i", minutes, seconds)
        }
    }
}


extension UIViewController
{
    var App_Delegate:AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }
    
    func configureChildViewController(childController: UIViewController, onView: UIView?) {
        var holderView = self.view
        if let onView = onView {
            holderView = onView
        }
        addChild(childController)
        holderView?.addSubview(childController.view)
        constrainViewEqual(holderView: holderView!, view: childController.view)
        childController.didMove(toParent: self)
        childController.willMove(toParent: self)
    }
    
    func constrainViewEqual(holderView: UIView, view: UIView) {
        view.translatesAutoresizingMaskIntoConstraints = false
        //pin 100 points from the top of the super
        let pinTop = NSLayoutConstraint(item: view, attribute: .top, relatedBy: .equal,
                                        toItem: holderView, attribute: .top, multiplier: 1.0, constant: 0)
        let pinBottom = NSLayoutConstraint(item: view, attribute: .bottom, relatedBy: .equal,
                                           toItem: holderView, attribute: .bottom, multiplier: 1.0, constant: 0)
        let pinLeft = NSLayoutConstraint(item: view, attribute: .left, relatedBy: .equal,
                                         toItem: holderView, attribute: .left, multiplier: 1.0, constant: 0)
        let pinRight = NSLayoutConstraint(item: view, attribute: .right, relatedBy: .equal,
                                          toItem: holderView, attribute: .right, multiplier: 1.0, constant: 0)
        
        holderView.addConstraints([pinTop, pinBottom, pinLeft, pinRight])
    }
    
    func Show_HUD()
    {
        DispatchQueue.main.async {
            JTProgressHUD.show()
        }
        
    }

    func HideHUD()
    {
        DispatchQueue.main.async {
            JTProgressHUD.hide()
        }
        
    }
    
    
    public func heightForWidth(_ width: CGFloat, imageSize: CGSize) -> CGFloat
    {
        let boundingRect = CGRect(
            x: 0,
            y: 0,
            width: width,
            height: CGFloat(MAXFLOAT)
        )
        let rect = AVMakeRect(
            aspectRatio: imageSize,
            insideRect: boundingRect
        )
        return rect.size.height
    }
    
    func showAlert(title: String ,message: String, linkHandler: ((UIAlertAction) -> Void)? ){
        let alertController = UIAlertController.init(title: title.localized, message: message.localized, preferredStyle: .alert)
        alertController.addAction(UIAlertAction.init(title: "Ok".localized, style: .default, handler:linkHandler))
        self.present(alertController, animated: true, completion: nil);
    }
    
    func showLinkAlert(title: String ,message: String, linkTitle:String, linkHandler: ((UIAlertAction) -> Void)? ){
        let alertController = UIAlertController.init(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction.init(title: "Cancel".localized, style: .cancel, handler: nil))
        alertController.addAction(UIAlertAction.init(title: linkTitle, style: .default, handler:linkHandler))
        self.present(alertController, animated: true, completion: nil);
    }
    
    func createFolder(dirName: String) -> Bool {
        var path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        path = path.appendingPathComponent(path: dirName)
        if !FileManager.default.fileExists(atPath: path) {
            do {
                try FileManager.default.createDirectory(at: URL(fileURLWithPath: path), withIntermediateDirectories: false, attributes: nil)
                return true
            }
            catch {
                print("createFolder error: %@", error.localizedDescription)
                 return false
            }
        }else{
            let alertController = UIAlertController.init(title: "Error".localized, message: "directory already created.".localized, preferredStyle: .alert)
            alertController.addAction(UIAlertAction.init(title: "OK".localized, style: .cancel, handler: nil))
            self.present(alertController, animated: true, completion: nil);
            return false
        }
    }
    
    @IBAction func clk_NavBack(){
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func clk_Dismiss(){
        self.dismiss(animated: true, completion: nil)
    }
    
    
    func Toast(message: String? ){
        let alertVC = UIAlertController.init(title: "", message: message?.localized, preferredStyle: .alert);
        alertVC.addAction(UIAlertAction.init(title: "Ok".localized, style: .default, handler: nil))
        self.present(alertVC, animated: true, completion: nil)
    }
    
    func ToastRoot(message: String? ){
        if let vc = self.App_Delegate.window?.rootViewController {
            let alertVC = UIAlertController.init(title: "", message: message?.localized, preferredStyle: .alert);
            alertVC.addAction(UIAlertAction.init(title: "Ok".localized, style: .default, handler: nil))
            vc.present(alertVC, animated: true, completion: nil)
        }
    }
    
    var appUUidString: String {
        return UIDevice.current.identifierForVendor?.uuidString ?? ""
    }


}



extension URLSession {
    
    var tempPath: String?{
        get {
            guard  let value = objc_getAssociatedObject(self, &AssociatedKeys.tempPath) as? String else {
                return nil
            }
            return value
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.tempPath, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    var videoID: String{
        get {
            guard  let value = objc_getAssociatedObject(self, &AssociatedKeys.videoID) as? String else {
                return ""
            }
            return value
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.videoID, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}

enum UserDefaultsKeys : String {
    case isLoggedIn
    case userID
}

extension NSDictionary
{
    func prettyPrint()
    {
        for (key,value) in self {
            print("\(key) = \(value)")
        }
    }
}

extension UITableView
{
    func setAndLayoutTableHeaderView(header: UIView) {
        self.tableHeaderView = header
        header.setNeedsLayout()
        header.layoutIfNeeded()
        header.frame.size = header.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
        self.tableHeaderView = header
    }
    
    func scrollToBottom()
    {
        DispatchQueue.main.async {
            let indexPath = IndexPath(
                row: self.numberOfRows(inSection:  self.numberOfSections - 1) - 1,
                section: self.numberOfSections - 1)
            self.scrollToRow(at: indexPath, at: .bottom, animated: true)
        }
    }
    
    func scrollToTop() {
        
        DispatchQueue.main.async {
            let indexPath = IndexPath(row: 0, section: 0)
            self.scrollToRow(at: indexPath, at: .top, animated: false)
        }
    }
}


public extension UIImage
{
    func heightForWidth(width: CGFloat) -> CGFloat
    {
        let boundingRect = CGRect(
            x: 0,
            y: 0,
            width: width,
            height: CGFloat(MAXFLOAT)
        )
        let rect = AVMakeRect(
            aspectRatio: size,
            insideRect: boundingRect
        )
        return rect.size.height
    }
    
    func imageWithImage(newSize: CGSize) -> UIImage {
        let scaleFactor = newSize.width / self.size.width
        let newHeight = self.size.height * scaleFactor
        let newWidth = self.size.width * scaleFactor;
        UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newHeight))
        self.draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return newImage!
    }
}

extension UILabel
{
    func retrieveTextHeight() -> CGFloat
    {
        let attributedText = NSAttributedString(string: self.text!, attributes: [CoreText.kCTFontAttributeName as NSAttributedString.Key:self.font as Any])
        let rect = attributedText.boundingRect(with: CGSize(width: self.frame.size.width, height: CGFloat.greatestFiniteMagnitude), options: .usesLineFragmentOrigin, context: nil)
        return ceil(rect.size.height)
    }
}

extension UIResponder {
    
    func next<T: UIResponder>(_ type: T.Type) -> T? {
        return next as? T ?? next?.next(type)
    }
}


extension URLSession
{
    func synchronousDataTask(urlrequest: URLRequest) -> (data: Data?, response: URLResponse?, error: Error?) {
        var data: Data?
        var response: URLResponse?
        var error: Error?
        
        let semaphore = DispatchSemaphore(value: 0)
        
        let dataTask = self.dataTask(with: urlrequest) {
            data = $0
            response = $1
            error = $2
            
            semaphore.signal()
        }
        dataTask.resume()
        
        _ = semaphore.wait(timeout: .distantFuture)
        
        return (data, response, error)
    }
}

enum FileType: Int {
    case  photo = 0, video, audio, note, document, other
}

extension String {
    func appendingPathComponent(path: String) -> String {
        return (self as NSString).appendingPathComponent(path)
    }
    
    func appendingPathExtension(ext: String) -> String? {
        return (self as NSString).appendingPathExtension(ext)
    }
    
    var lastPathComponent: String {
        return (self as NSString).lastPathComponent
    }
    var pathExtension: String {
        return (self as NSString).pathExtension
    }
    var deletingLastPathComponent: String {
        return (self as NSString).deletingLastPathComponent
    }
    var deletingPathExtension: String {
        return (self as NSString).deletingPathExtension
    }
    var pathComponents: [String] {
        return (self as NSString).pathComponents
    }
    
    var isValidFile: Bool {
        do {
            // png|jpg|jpeg|mp4|mov|avi|flv|3gp|h264|mpeg|mpg|mp3|m4a|aac|wav|wma|txt|text|rtf|pdf|doc|docx|xls
            let regex = try NSRegularExpression(pattern: "^.+\\.(png|jpg|jpeg|mp4|mov|avi|flv|3gp|h264|mpeg|mpg|mp3|m4a|aac|wav|wma|txt|text)$", options: [])
            return regex.matches(in: self, options: [], range: NSRange(location:0, length: self.count)).count > 0
        } catch {
            print("isValidFile : %@", error.localizedDescription)
            return false
        }
    }
    
    var  isValidFilePhotoVideo: Bool {
        do {
            let regex = try NSRegularExpression(pattern: "^.+\\.(png|jpg|jpeg)$", options: [])
            return regex.matches(in: self, options: [], range: NSRange(location:0, length: self.count)).count > 0
        } catch {
            print("isValidFile : %@", error.localizedDescription)
            return false
        }
    }
    
    var  isValidFilePhoto: Bool {
        do {
            let regex = try NSRegularExpression(pattern: "^.+\\.(png|jpg|jpeg)$", options: [])
            return regex.matches(in: self, options: [], range: NSRange(location:0, length: self.count)).count > 0
        } catch {
            print("isValidFile : %@", error.localizedDescription)
            return false
        }
    }
    
    var  isValidFileVideo: Bool {
        do {
            let regex = try NSRegularExpression(pattern: "^.+\\.(mp4|mov|avi|flv|3gp|h264|mpeg|mpg)$", options: [])
            return regex.matches(in: self, options: [], range: NSRange(location:0, length: self.count)).count > 0
        } catch {
            print("isValidFile : %@", error.localizedDescription)
            return false
        }
    }
    
    var isValidFileAudio: Bool {
        do {
            let regex = try NSRegularExpression(pattern: "^.+\\.(mp3|m4a|aac|ogg|wav|wma)$", options: [])
            return regex.matches(in: self, options: [], range: NSRange(location:0, length: self.count)).count > 0
        } catch {
            print("isValidFile : %@", error.localizedDescription)
            return false
        }
    }
    
    var isValidFileNote: Bool {
        do {
            let regex = try NSRegularExpression(pattern: "^.+\\.(txt|text)$", options: [])
            return regex.matches(in: self, options: [], range: NSRange(location:0, length: self.count)).count > 0
        } catch {
            print("isValidFile : %@", error.localizedDescription)
            return false
        }
    }
    
    var isValidFileDocument: Bool {
        do {
            let regex = try NSRegularExpression(pattern: "^.+\\.(pdf|doc|docx|rtf|xls)$", options: [])
            return regex.matches(in: self, options: [], range: NSRange(location:0, length: self.count)).count > 0
        } catch {
            print("isValidFile : %@", error.localizedDescription)
            return false
        }
    }
    
    var file_type: FileType {
        if self.isValidFilePhoto {
            return .photo
        }else if  self.isValidFileVideo {
            return .video
        }else if  self.isValidFileAudio {
            return .audio
        }else if  self.isValidFileNote {
            return .note
        }else if  self.isValidFileDocument {
            return .document
        }else{
            return .other
        }
    }
    
    func getDateTime(formate: String = "EEEE, MMM dd")-> String {
        
        if(self == "") {
            return ""
        }
        let dt = DateFormatter()
        dt.dateFormat = formate
        return dt.string(from: Date(timeIntervalSince1970: (Double(self) ?? 0.0) as TimeInterval))
    }
    
    func UTCToLocal(formate: String = "EEEE, MMM dd") -> String {
        
        if(self == "") {
            return ""
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d yyyy H:mm"
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        
        let dt = dateFormatter.date(from: self)
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = formate
        return dateFormatter.string(from: dt!)
    }
    
    
    var localized: String {
        return NSLocalizedString(self, tableName: nil, bundle: Bundle.main, value: "", comment: "")
    }
    
    public static func localize(key: String, comment: String = "") -> String {
        return NSLocalizedString(key, comment: comment)
    }
    
    
}

extension FileManager {
    func secureCopyItem(at srcURL: URL, to dstURL: URL) -> Bool {
        do {
            if FileManager.default.fileExists(atPath: dstURL.path) {
                try FileManager.default.removeItem(at: dstURL)
            }
            try FileManager.default.copyItem(at: srcURL, to: dstURL)
        } catch (let error) {
            print("Cannot copy item at \(srcURL) to \(dstURL): \(error)")
            return false
        }
        return true
    }
}

struct AssociatedKeys {
    static var languageInput: UInt8 = 0
    static var tempPath:  UInt8 = 1
    static var videoID:  UInt8 = 2
    
    static var btnText: UInt8 = 3
    static var btnAnimation: UInt8 = 4
}


extension UITextField {
    
    @IBInspectable var languageInput: String{
        get {
            guard  let value = objc_getAssociatedObject(self, &AssociatedKeys.languageInput) as? String else {
                return "gu"
            }
            return value
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.languageInput, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    override open var textInputMode: UITextInputMode? {
//        if let language = {
            for tim in UITextInputMode.activeInputModes {
                if tim.primaryLanguage!.contains(self.languageInput) {
                    return tim
                }
            }
//        }
        return super.textInputMode
    }
}

extension UITextView {
    
    @IBInspectable var languageInput: String{
        get {
            guard  let value = objc_getAssociatedObject(self, &AssociatedKeys.languageInput) as? String else {
                return "gu"
            }
            return value
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.languageInput, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    override open var textInputMode: UITextInputMode? {
        //        if let language = {
        for tim in UITextInputMode.activeInputModes {
            if tim.primaryLanguage!.contains(self.languageInput) {
                return tim
            }
        }
        //        }
        return super.textInputMode
    }
}

/*
//MARK: UIImagePickerControllerDelegate

@IBAction func clk_ImagePicker(sender: UIControl){
    let alertController = UIAlertController.init(title: "", message: "Choose Option", preferredStyle: .actionSheet)
    alertController.addAction( UIAlertAction.init(title: "Camera", style: .default) { (action) in
        self.openCamera()
        
    })
    alertController.addAction(UIAlertAction.init(title: "Media Library", style: .default) { (action) in
        self.openPhotoLibrary()
    })
    
    alertController.addAction(UIAlertAction.init(title: "Cancel", style: .cancel));
    self.present(alertController, animated: true, completion: nil)
}

func openCamera() {
    if(UIImagePickerController .isSourceTypeAvailable(.camera)){
        self.openImagePicker(type: .camera)
    }else{
        self.showAlert(title: "Not Open Camera", message: "Not Decive Supported" , linkHandler: nil)
    }
}

func openPhotoLibrary() {
    self.openImagePicker(type: .photoLibrary)
}

func openImagePicker(type : UIImagePickerController.SourceType){
    let picker = UIImagePickerController()
    picker.delegate = self
    if(UIImagePickerController.isSourceTypeAvailable(.camera) && type == .camera){
        picker.sourceType = .camera
        picker.showsCameraControls = true
        picker.cameraDevice = .rear
    }else{
        picker.sourceType =  .photoLibrary
    }
    self.present(picker, animated: true, completion: nil)
}

func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    let img = (info as NSDictionary).object(forKey: UIImagePickerController.InfoKey.originalImage)
    imgUser?.image =  (img as! UIImage)
    self.ServiceCall_UpdateProfileImage(parameter: [
        "user_id": self.App_Delegate.userPayload.value(forKey: Globs.kkeyUserID) ?? ""] as NSDictionary, image: imgUser?.image)
    picker.dismiss(animated: true, completion: nil)
}

func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
    picker.dismiss(animated: true, completion: nil)
} */
