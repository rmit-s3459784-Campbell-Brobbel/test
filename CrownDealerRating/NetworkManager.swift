//
//  NetworkManager.swift
//  CrownDealerRating
//
//  Created by Campbell Brobbel on 7/8/17.
//  Copyright © 2017 Campbell Brobbel. All rights reserved.
//

import Foundation

class NetworkManager {
    
    init() {
        
    }
    
    public static func post(jsonObject : NSDictionary, toURLPath : String,  completion: @escaping (_ : Data?) -> Void) {
        let url: URL = URL(string: toURLPath)!
        var request : URLRequest = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            let data = try JSONSerialization.data(withJSONObject: jsonObject, options: [])
            request.httpBody = data
            
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                
                if error != nil {
                    print("Download Error")
                    print(error!.localizedDescription)
                    
                    
                }
                else {
                    DispatchQueue.main.async(execute: {
                        completion(data)
                    })
                }
                
            }
            task.resume()
        }
        catch let error {
            print(error.localizedDescription)
        }
        
    }
    

}
