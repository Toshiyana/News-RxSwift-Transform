//
//  Article.swift
//  News-RxSwift-Transform
//
//  Created by Toshiyana on 2021/12/07.
//

import Foundation

struct ArticleList: Decodable {
    let articles: [Article]
}

extension ArticleList {
    static var all: Resource<ArticleList> = {
        let url = URL(string: "https://newsapi.org/v2/everything?q=Apple&from=2021-12-06&sortBy=popularity&apiKey=06b76736facf4432bcfd15d554f2cb08")!
        return Resource(url: url)
    }()
}

struct Article: Decodable {
    let title: String
    // In case of decoding error, use optional with description (<- ex: when not including description in json)
    let description: String?
}
