//
//  OneNews.swift
//  News
//
//  Created by Vladimir Stepanchikov on 05.04.2020.
//  Copyright © 2020 Vladimir Stepanchikov. All rights reserved.
//

/*
"source": {
"id": "the-irish-times",
"name": "The Irish Times"
},
"author": "The Irish Times",
"title": "LIVE Coronavirus: US prepares for 'very horrendous' rise in deaths",
"description": "President Donald Trump repeats support for drug that is still being tested to treat Covid-19",
"url": "https://www.irishtimes.com/news/ireland/irish-news/coronavirus-us-prepares-for-very-horrendous-rise-in-deaths-1.4221258",
"urlToImage": "https://www.irishtimes.com/image-creator/?id=1.4221260&origw=1280",
"publishedAt": "2020-04-05T09:23:19.1660746Z",
"content": null
*/

import Foundation

struct OneNews {
    var sourceId: String
    var sourceName: String
    var author: String
    var title: String
    var description: String
    var url: String
    var urlToImage: String
    var publishedAt: String
    var content: String
    
    init(dictionaryOneNews: [String: Any]) {
        sourceId = (dictionaryOneNews["source"] as? [String: String])?["id"] ?? ""
        sourceName = (dictionaryOneNews["source"] as? [String: String])?["name"] ?? ""
        author = dictionaryOneNews["author"] as? String ?? ""
        title = dictionaryOneNews["title"] as? String ?? ""
        description = dictionaryOneNews["description"] as? String ?? ""
        url = dictionaryOneNews["url"] as? String ?? ""
        urlToImage = dictionaryOneNews["urlToImage"] as? String ?? ""
        publishedAt = dictionaryOneNews["publishedAt"] as? String ?? ""
        content = dictionaryOneNews["content"] as? String ?? ""
        
    }
}
