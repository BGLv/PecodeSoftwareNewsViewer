//
//  NewsService.swift
//  PecodeSoftwareNewsViewer
//
//  Created by Bogdan Lviv on 9/10/19.
//  Copyright © 2019 Bogdan Lviv. All rights reserved.
//

import Foundation


//PUBLIC INTERFACE OF NewsService
extension NewsService {
    
    func getAvaliableSources(completion: @escaping ([Source]?)->Void){
        let networkProcessor = NetworkProcessor(url: makeAvaliableSourceURLComponent().url!)
        getAllAvaliableSources(byNetworkProcessor: networkProcessor, completion: completion)
    }
    
    func getTopNews(byString string: String?,byCategory category:String?, byCountry country: String?, fromSourceID sourceID:String?,completion: @escaping ([Article]?)->Void){
        let networkProcessor = NetworkProcessor(url: makeTopNewsURLComponent(stringToSearch: string, category: category, country: country, sourceID: sourceID).url!)
        getNewsByNetworkProcessor(byNetworkProcessor: networkProcessor, completion: completion)
    }
    
    func getEveryNewsSearched(byString string: String, completion: @escaping ([Article]?)->Void){
        let networkProcessor = NetworkProcessor(url: makeSearchEveryNewsByStringURLComponent(stringToSearch: string).url!)
        getNewsByNetworkProcessor(byNetworkProcessor: networkProcessor, completion: completion)
    }
    
}

class NewsService {
    
    var country: String?
    var source: String?
    
    struct NewsAPI {
        static let scheme = "https"
        static let host = "newsapi.org"
        static let pathTopNews = "/v2/top-headlines"
        static let pathEveryNews = "/v2/everything"
        static let pathToSources = "/v2/sources"
        //WARNING: Insert your own newsapi.org apiKey inside newsServiceSettings.plist
        static var apiKey: String {
            let pathToSettings = Bundle.main.path(forResource: "newsServiceSettings", ofType: "plist")
            let settingsDictionary = NSDictionary(contentsOf: URL.init(fileURLWithPath: pathToSettings!)) as! [String:String]
            return settingsDictionary["apiKey"]!
        }
        //WARNING: Insert your own country inside newsServiceSettings.plist (by default: ua)
        static var defaultCountry: String {
            let pathToSettings = Bundle.main.path(forResource: "newsServiceSettings", ofType: "plist")
            let settingsDictionary = NSDictionary(contentsOf: URL.init(fileURLWithPath: pathToSettings!)) as! [String:String]
            return settingsDictionary["country"]!
        }
    }
    
    
    private func makeAvaliableSourceURLComponent() -> URLComponents{
        var components = URLComponents()
        components.scheme = NewsAPI.scheme
        components.host = NewsAPI.host
        components.path = NewsAPI.pathToSources
        
        components.queryItems = [
            URLQueryItem(name: "apiKey", value: NewsAPI.apiKey)
        ]
        
        return components
    }
    
    
    private func makeTopNewsURLComponent(stringToSearch: String?, category:String?, country:String?, sourceID:String?) -> URLComponents{
        var components = URLComponents()
        components.scheme = NewsAPI.scheme
        components.host = NewsAPI.host
        components.path = NewsAPI.pathTopNews
        source=sourceID
        
        components.queryItems = [
            URLQueryItem(name: (source != nil) ? "sources" : "country", value:source ?? country ?? NewsAPI.defaultCountry),
            URLQueryItem(name: "apiKey", value: NewsAPI.apiKey)
        ]
        
        if let category = category{
            if nil == source {
                components.queryItems?.append(URLQueryItem(name: "category", value: category))
            }
        }
        
        if let string = stringToSearch {
            components.queryItems?.append(URLQueryItem(name: "q", value: string))
        }
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
    
    
    private func getAllAvaliableSources(byNetworkProcessor networkProcessor:NetworkProcessor, completion: @escaping ([Source]?)->Void){
        networkProcessor.downloadJSONFromUrl { (jsonDictionary) in
            var sources: [Source] = [];
            if let sourcesFromJSON = jsonDictionary?["sources"] as? [[String : Any]] {
                for sourceFromJSON in sourcesFromJSON {
                    if let id = sourceFromJSON["id"] as? String,
                        let name = sourceFromJSON["name"] as? String{
                        sources.append(Source(byId: id, byName: name))
                    }
                }
            }
            completion(sources)
        }
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
