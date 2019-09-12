//
//  topNews.swift
//  PecodeSoftwareNewsViewer
//
//  Created by Bogdan Lviv on 9/10/19.
//  Copyright © 2019 Bogdan Lviv. All rights reserved.
//

import Foundation

struct Article {
    let source: [String:String?]?
    let author: String?
    let title: String?
    let description: String?
    let imageURL: String?
    let publishedAt: String?
    let totalArticles: Int?
    
    init(fromSource source: [String:String?]?, byAuthor author: String?, byTitle title: String?, byDescription description: String?, byImageURL imageURL: String?, byPublishedAt publishedAt: String?, totalArticles: Int?) {
        self.source = source
        self.author = author
        self.title = title
        self.description = description
        self.imageURL = imageURL
        self.publishedAt=publishedAt
        self.totalArticles=totalArticles
    }
}
