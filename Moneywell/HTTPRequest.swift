//
//  HTTPRequest.swift
//  Moneywell
//
//  Created by Faza Fahleraz on 23/02/19.
//  Copyright © 2019 Abram Situmorang. All rights reserved.
//

import Foundation

class HTTPRequest {
    let task: URLSessionDataTask
    
    init(url: String, completionHandler: @escaping (_ result: [String: Any]) -> Void) {
        let urlSession = URLSession.shared
        let getRequest = URLRequest(url: URL(string: url)!)
        self.task = urlSession.dataTask(with: getRequest as URLRequest, completionHandler: { (data, response, error) in
                guard error == nil else {
                    return
                }
                guard let data = data else {
                    return
                }
                do {
                    // parse JSON result into a dictionary of type [String: Any]
                    if let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] {
                        completionHandler(json)
                    } else {
                        print("JSON parsing failed.")
                    }
                } catch let error {
                    print(error.localizedDescription)
                }
            }
        )
    }
    
    func resume() {
        self.task.resume()
    }
    
    func cancel() {
        self.task.cancel()
    }
}
