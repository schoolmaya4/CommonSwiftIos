//
//  MDServiceCall.swift
//
//  Created by Shiv on 03/05/19.
//  Copyright © 2019 MVD. All rights reserved.
//

import UIKit

class MDServiceCall: NSObject {
    
    
    
    class func App_Delegate() -> AppDelegate {
            return UIApplication.shared.delegate as! AppDelegate
    }
    
    class func service_callGET(parameter:NSDictionary,path:String,withSuccess: @escaping ((_ responseObj: Any?) -> Void), failure:@escaping ((_ error: Error?) -> Void))
    {
        
        
        DispatchQueue.global(qos: .userInitiated).async
            {
                
                let parameterData = NSMutableString.init()
                let dictKey:[String] = parameter.allKeys as! [String]
                var i=0;
                
                //User-Agent
                let headers = ["cache-control": "no-cache","content-type": "text/plain"]
                
                for dictK:String in dictKey
                {
                    
                    parameterData.appendFormat("%@%@=%@", i==0 ? "?" : "&" ,dictK, parameter.value(forKey: dictK)  as! CVarArg)
                    //                    parameterData.append(String.init(format: ).data(using: String.Encoding.utf8)!)
                    i += 1
                }
                
                let request = NSMutableURLRequest(url: NSURL(string:String(format: "%@%@", path, parameterData))! as URL, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10.0)
                request.httpMethod = "GET"
                request.allHTTPHeaderFields = headers
                
                let session = URLSession.shared
                let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
                    if (error != nil)
                    {
                        DispatchQueue.main.async {
                            failure(error)
                        }
                    }
                    else
                    {
                        do
                        {
                            
                            let jsonDictionary = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers)
                            Dlog(" response" , jsonDictionary)
                            DispatchQueue.main.async {
                                withSuccess(jsonDictionary)
                            }
                        }
                        catch
                        {
                            print(error.localizedDescription)
                            DispatchQueue.main.async {
                                failure(error)
                            }
                        }
                    }
                })
                dataTask.resume()
        }
    }
    

    
    class func service_callPOST(parameter:NSDictionary,path:String,withSuccess: @escaping ((_ responseObj: AnyObject?) -> Void), failure:@escaping ((_ error: Error?) -> Void))
    {

        DispatchQueue.global(qos: .userInitiated).async
            {
                let headers = ["content-type": "application/x-www-form-urlencoded", "cache-control": "no-cache"]
                let parameterData = NSMutableData.init()
                let dictKey:[String] = parameter.allKeys as! [String]
                var i=0;
                
                for dictK:String in dictKey
                {
                    
                    if let vales = parameter.value(forKey: dictK) as? String {
                        parameterData.append(String.init(format: "%@%@=%@", i==0 ? "" : "&" ,dictK, vales.replacingOccurrences(of: "+", with: "%2B")).data(using: String.Encoding.utf8)!)
                    }else{
                        parameterData.append(String.init(format: "%@%@=%@", i==0 ? "" : "&" ,dictK, parameter.value(forKey: dictK)  as! CVarArg).data(using: String.Encoding.utf8)!)
                    }
                    
                    
                    i += 1
                }
                
                let request = NSMutableURLRequest(url: NSURL(string: path)! as URL, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10.0)
                request.httpMethod = "POST"
                request.allHTTPHeaderFields = headers
                request.httpBody = parameterData as Data
                
                let session = URLSession.shared
                let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
                    if (error != nil)
                    {
                        DispatchQueue.main.async {
                            failure(error)
                        }
                    }
                    else
                    {
                        do
                        {
                            let jsonDictionary:NSDictionary;
                            jsonDictionary = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSDictionary
                            Dlog(" response" , jsonDictionary)
                            DispatchQueue.main.async {
                                withSuccess(jsonDictionary)
                            }
                        }
                        catch
                        {
                            print(error.localizedDescription)
                            DispatchQueue.main.async {
                                failure(error)
                            }
                        }
                    }
                })
                dataTask.resume()
        }
    }
    
    class func service_callImageDicPOST(parameter:NSDictionary,path:String, imageDic:NSDictionary ,withSuccess: @escaping ((_ responseObj: AnyObject?) -> Void), failure:@escaping ((_ error: Error?) -> Void))
    {
        
        DispatchQueue.global(qos: .userInitiated).async {
            
            let boundary = "----WebKitFormBoundary7MA4YWxkTrZu0gW"
            let headers = [
                "content-type": "multipart/form-data; boundary=----WebKitFormBoundary7MA4YWxkTrZu0gW",
                "cache-control": "no-cache",
                "Postman-Token": "3452ea41-abaa-3c0b-8b16-f876e0f301e8"
            ]
            let request = NSMutableURLRequest(url: NSURL(string: path)! as URL, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10.0)
            request.httpMethod = "POST"
            request.allHTTPHeaderFields = headers
            
            let body = NSMutableData();
            for (key, value) in parameter
            {
                body.appendString(string: "\r\n--\(boundary)\r\n")
                body.appendString(string: "Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
                body.appendString(string: "\(value)")
            }
            
            for (key, value) in imageDic
            {
                body.appendString(string: "\r\n--\(boundary)\r\n")
                body.appendString(string: "Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
                body.appendString(string: "\(value)\r\n")
                
                let filename = "\(UUID().uuidString).MOV"
                let mimetype = "video/quicktime"
                body.appendString(string: "--\(boundary)\r\n")
                body.appendString(string: "Content-Disposition: form-data; name=\"\(key)\"; filename=\"\(filename)\"\r\n")
                body.appendString(string: "Content-Type: \(mimetype)\r\n\r\n")
                body.append(value as! Data)
                
            }
            
            body.appendString(string: "\r\n--\(boundary)--\r\n")
            request.httpBody = body as Data
            
            let datastring = NSString(data: body as Data, encoding: String.Encoding.utf8.rawValue)
            print(datastring as Any)
            
            let session = URLSession.shared
            let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
                if (error != nil)
                {
                    DispatchQueue.main.async {
                        failure(error)
                    }
                }
                else
                {
                    do
                    {
                        let jsonDictionary:NSDictionary;
                        jsonDictionary = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSDictionary
                        Dlog(" response" , jsonDictionary)
                        DispatchQueue.main.async {
                            withSuccess(jsonDictionary)
                        }
                    }
                    catch
                    {
                        print(error.localizedDescription)
                        DispatchQueue.main.async {
                            failure(error)
                        }
                    }
                }
            })
            dataTask.resume()
        }
    }
    
    class func service_callImagePOST(parameter:NSDictionary,path:String,image:UIImage?,withSuccess: @escaping ((_ responseObj: AnyObject?) -> Void), failure:@escaping ((_ error: Error?) -> Void))
    {
        
        DispatchQueue.global(qos: .userInitiated).async {
            
            let boundary = "----WebKitFormBoundary7MA4YWxkTrZu0gW"
            let headers = [
                "content-type": "multipart/form-data; boundary=----WebKitFormBoundary7MA4YWxkTrZu0gW",
                "Cache-Control": "no-cache",
                "Postman-Token": "3452ea41-abaa-3c0b-8b16-f876e0f301e8"
            ]
            let request = NSMutableURLRequest(url: NSURL(string:path)! as URL, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10.0)
            request.httpMethod = "POST"
            request.allHTTPHeaderFields = headers
            
            let body = NSMutableData();
            for (key, value) in parameter
            {
                body.appendString(string: "--\(boundary)\r\n")
                body.appendString(string: "Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
                body.appendString(string: "\(value)\r\n")
            }
            if (image != nil) {
                let filename = "\(UUID().uuidString).jpg"
                let mimetype = "image/jpg"
                body.appendString(string: "--\(boundary)\r\n")
                body.appendString(string: "Content-Disposition: form-data; name=\"image\"; filename=\"\(filename)\"\r\n")
                body.appendString(string: "Content-Type: \(mimetype)\r\n\r\n")
                body.append(image!.jpegData(compressionQuality: 0.5)!)
                body.appendString(string: "\r\n")
                body.appendString(string: "--\(boundary)--\r\n")
            }
            request.httpBody = body as Data
            
            let datastring = NSString(data: body as Data, encoding: String.Encoding.utf8.rawValue)
            print(datastring as Any)
            
            let session = URLSession.shared
            let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
                if (error != nil)
                {
                    DispatchQueue.main.async {
                        failure(error)
                    }
                }
                else
                {
                    do
                    {
                        let jsonDictionary:NSDictionary;
                        jsonDictionary = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSDictionary
                        Dlog(" response" , jsonDictionary)
                        DispatchQueue.main.async {
                            withSuccess(jsonDictionary)
                        }
                    }
                    catch
                    {
                        print(error.localizedDescription)
                        DispatchQueue.main.async {
                            failure(error)
                        }
                    }
                }
            })
            dataTask.resume()
        }
    }
}


extension NSMutableData
{
    func appendString(string: String) {
        let data = string.data(using: String.Encoding.utf8, allowLossyConversion: true)
        append(data!)
    }
}
