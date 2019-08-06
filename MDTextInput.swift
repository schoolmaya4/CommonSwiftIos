//
//  MDTextInput.swift
//
//  Created by Shiv on 11/05/19.
//  Copyright © 2019 MVD. All rights reserved.
//

import Foundation
import SearchTextField

extension SearchTextField {
    override open func awakeFromNib() {
        super.awakeFromNib()
        
        self.maxNumberOfResults = 5
        self.forceNoFiltering = true
        self.theme.font = UIFont.systemFont(ofSize: 14)
        self.theme.bgColor = UIColor (red: 0.95, green: 0.95, blue: 0.95, alpha: 0.5)
        self.theme.borderColor = UIColor (red: 0.9, green: 0.9, blue: 0.9, alpha: 1)
        self.theme.separatorColor = UIColor (red: 0.95, green: 0.95, blue: 0.95, alpha: 0.5)
        self.theme.cellHeight = 30

        self.itemSelectionHandler = { filteredResults, itemPosition in
            let item = filteredResults[itemPosition]
            self.text = item.title
        }
        
        self.userStoppedTypingHandler = {
            if let criteria = self.text {
                if criteria.count > 1 {
                    
                    // Show loading indicator
                    self.showLoadingIndicator()
                    
                    self.filterAcronymInBackground(criteria) { results in
                        // Set new items to filter
                        self.filterItems(results)
                        
                        // Stop loading indicator
                        self.stopLoadingIndicator()
                    }
                }
            }
            } as (() -> Void)
    }
    
    
    fileprivate func filterAcronymInBackground(_ criteria: String, callback: @escaping ((_ results: [SearchTextFieldItem]) -> Void)) {
        let url = URL(string: "criteria".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "" )
        if let url = url {
            let task = URLSession.shared.dataTask(with: url, completionHandler: {(data, response, error) in
                do {
                    if let data = data {
                        if let jsonData = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? NSArray, jsonData.count > 1, let success = jsonData[0] as? String, success == "SUCCESS",let payloadArray =  jsonData[1] as? NSArray,payloadArray.count > 0, let fillerArray = payloadArray[0] as? NSArray, fillerArray.count > 1 , let finalData = fillerArray[1] as? [String]{
                            
                            var results = [SearchTextFieldItem]()
                            for result in finalData {
                                results.append(SearchTextFieldItem(title: result))
                            }
                            DispatchQueue.main.async {
                                callback(results)
                            }
                            
                        }else{
                            DispatchQueue.main.async {
                                callback([])
                            }
                        }
                        
                    } else {
                        DispatchQueue.main.async {
                            callback([])
                        }
                    }
                }
                catch {
                    print("Network error: \(error)")
                    DispatchQueue.main.async {
                        callback([])
                    }
                }
            })
            
            task.resume()
        }
    }
}



