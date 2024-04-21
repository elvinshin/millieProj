//
//  Model.swift
//  millieProj
//
//  Created by shin on 4/20/24.
//

import Foundation
import ObjectMapper
 
/* response sample
 "status": "ok",
 "totalResults": 34,
 "articles": [
   {
     "source": {
       "id": null,
       "name": "Chosun.com"
     },
     "author": "조선일보",
     "title": "현주엽 측 “‘실화탐사대’ 입장 100% 반영 NO..논란 키웠다” (전문)[공식입장] - 조선일보",
     "description": "현주엽 측 실화탐사대 입장 100% 반영 NO..논란 키웠다 전문공식입장",
     "url": "https://www.chosun.com/entertainments/broadcast/2024/04/19/PZYFZM5T2GGBAIRQJWF7VJSXWY/",
     "urlToImage": "https://images.chosun.com/resizer/on9SdDeDiLHRo1E0I3Iz-iJe3AU=/530x278/smart/cloudfront-ap-northeast-1.images.arcpublishing.com/chosun/XRKIS6EVYIYMM4WBIG57A4DDAA.jpg",
     "publishedAt": "2024-04-19T02:21:42Z",
     "content": null
   },
*/

class Response:Mappable {
    var status:String = ""
    var totalResults:Int = 0
    var articles:[Article] = []
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        status <- map["status"]
        totalResults <- map["totalResults"]
        articles <- map["articles"]
    }
}

class Article:Mappable {
    var source:ArticleSource? // not used
    var author:String = "" // not used
    var title:String = ""
    var description:String = "" // not used
    var url:String = ""
    var urlToImage:String = ""
    var publishedAt:String = ""
    var content:String = "" // not used
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        source <- map["source"]
        author <- map["author"]
        title <- map["title"]
        url <- map["url"]
        urlToImage <- map["urlToImage"]
        description <- map["description"]
        publishedAt <- map["publishedAt"]
        content <- map["content"]
    }
}

class ArticleSource:Mappable {
    var id:Int = 0
    var name:String = ""
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
    }
}
