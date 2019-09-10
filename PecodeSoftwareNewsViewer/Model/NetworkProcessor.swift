//
//  NetworkProcessor.swift
//  PecodeSoftwareNewsViewer
//
//  Created by Bogdan Lviv on 9/10/19.
//  Copyright © 2019 Bogdan Lviv. All rights reserved.
//

import Foundation

class NetworkProcessor {
    
    private lazy var configuration: URLSessionConfiguration = URLSessionConfiguration.default
    private lazy var session: URLSession = URLSession(configuration: self.configuration)
    
    private let url: URL
    
    init(url:URL){
        self.url = url
    }
    
    typealias JSONDictionaryHandler = (([String:Any]?) -> Void)
    
    func downloadJSONFromUrl( completion: @escaping JSONDictionaryHandler){
        let request = URLRequest(url: self.url)
        let dataTask = self.session.dataTask(with: request) { (data, response, error) in
            if nil == error{
                if let httpResponse = response as? HTTPURLResponse {
                    switch(httpResponse.statusCode){
                    case 200:
                        //successful response
                        if let data = data {
                            do{
                            let jsonDictionary = try JSONSerialization.jsonObject(with: data, options: .mutableContainers)
                                completion(jsonDictionary as? [String:Any])
                            } catch let error as NSError{
                                print("Error processing json data: \(error.localizedDescription)")
                            }
                        }
                        break;
                    
                    default:
                        print("HTTP Response code: \(httpResponse.statusCode)")
                        break;
                    }
                }
            }else{
                print("Error: \(error!.localizedDescription)")
            }
        }
        dataTask.resume()
    }
}
