//
//  NewsService.swift
//  PecodeSoftwareNewsViewer
//
//  Created by Bogdan Lviv on 9/10/19.
//  Copyright © 2019 Bogdan Lviv. All rights reserved.
//

import Foundation

/*class NewsService {
 private var newsURL: URL?
 init() {
 self.newsURL = makeTopNewsURLComponent().url
 }
 }*/

//PUBLIC INTERFACE OF NewsService
extension NewsService {
    
    func getTopNews(completion: @escaping ([Article]?)->Void){
        let networkProcessor = NetworkProcessor(url: makeTopNewsURLComponent().url!)
        getNewsByNetworkProcessor(byNetworkProcessor: networkProcessor, completion: completion)
    }
    
    func getEveryNewsSearched(byString string: String, completion: @escaping ([Article]?)->Void){
        let networkProcessor = NetworkProcessor(url: makeSearchEveryNewsByStringURLComponent(stringToSearch: string).url!)
        getNewsByNetworkProcessor(byNetworkProcessor: networkProcessor, completion: completion)
    }
    
}

class NewsService {
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
    
    private func makeTopNewsURLComponent() -> URLComponents{
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
    
    private func makeSearchEveryNewsByStringURLComponent(stringToSearch: String) -> URLComponents {
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
    
    private func getNewsByNetworkProcessor(byNetworkProcessor networkProcessor:NetworkProcessor, completion: @escaping ([Article]?)->Void){
        networkProcessor.downloadJSONFromUrl { (jsonDictionary) in
            // completion(jsonDictionary?["articles"] as? [[String : Any]])
            var articles: [Article] = [];
            if let articlesFromJSON = jsonDictionary?["articles"] as? [[String : Any]] {
                for articleFromJSON in articlesFromJSON {
                    if let source = articleFromJSON["source"] as? [String:String?],
                        let author = articleFromJSON["author"] as? String,
                        let title = articleFromJSON["title"] as? String,
                        let description = articleFromJSON["description"] as? String,
                        let urlToImage = articleFromJSON["urlToImage"] as? String,
                        let publishedAt = articleFromJSON["publishedAt"] as? String{
                        
                        articles.append(Article(fromSource: source, byAuthor: author, byTitle: title, byDescription: description, byImageURL: urlToImage, byPublishedAt: publishedAt))
                    }
                }
            }
            completion(articles)
        }
    }
}
