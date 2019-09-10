//
//  NewsService.swift
//  PecodeSoftwareNewsViewer
//
//  Created by Bogdan Lviv on 9/10/19.
//  Copyright © 2019 Bogdan Lviv. All rights reserved.
//

import Foundation

class NewsService {
    private let newsURL: URL
    init(url: URL) {
        self.newsURL = url
    }
}

extension NewsService {
    func getTopNews(completion: @escaping (News?)->Void){
        
    }
}

private extension NewsService {
    struct NewsAPI {
        static let scheme = "https"
        static let host = "newsapi.org"
        static let pathTopNews = "/v2/top-headlines"
        static let pathEveryNews = "/v2/everything"
        //WARNING: Insert your own newsapi.org apiKey inside newsServiceSettings.plist
        static var apiKey: String {
            let pathToSettings = Bundle.main.path(forResource: "newsServiceSettings", ofType: "plist")
            let settingsDictionary = NSDictionary(contentsOf: URL.init(fileURLWithPath: pathToSettings!)) as! [String:String]
            return settingsDictionary["apiKey"]!
        }
        //WARNING: Insert your own country inside newsServiceSettings.plist (by default: ua)
        static var country: String {
            let pathToSettings = Bundle.main.path(forResource: "newsServiceSettings", ofType: "plist")
            let settingsDictionary = NSDictionary(contentsOf: URL.init(fileURLWithPath: pathToSettings!)) as! [String:String]
            return settingsDictionary["country"]!
        }
    }
    
    func makeTopNewsURLComponent() -> URLComponents{
        var components = URLComponents()
        components.scheme = NewsAPI.scheme
        components.host = NewsAPI.host
        components.path = NewsAPI.pathTopNews
        
        components.queryItems = [
            URLQueryItem(name: "country", value: NewsAPI.country),
            URLQueryItem(name: "apiKey", value: NewsAPI.apiKey)
        ]
        return components
    }
    
    func makeSearchEveryNewsByStringURLComponent(stringToSearch: String) -> URLComponents {
        var components = URLComponents()
        components.scheme = NewsAPI.scheme
        components.host = NewsAPI.host
        components.path = NewsAPI.pathEveryNews
        
        components.queryItems = [
            URLQueryItem(name: "q", value: stringToSearch),
            URLQueryItem(name: "apiKey", value: NewsAPI.apiKey)
        ]
        return components
    }
}
