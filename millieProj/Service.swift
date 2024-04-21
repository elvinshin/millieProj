//
//  Service.swift
//  millieProj
//
//  Created by shin on 4/20/24.
//

import Foundation
import Alamofire
import ObjectMapper
import RealmSwift

class NewsService{
    static func getHeadLineArticleList(completion:@escaping([Article],Bool)->()) {
        var params:[String:Any] = [:]
        params["country"] = "kr"
        params["apiKey"] = "efa9b6e3e58e4a6c8ef7a696da273ab1"
        AF.request("https://newsapi.org/v2/top-headlines",
                   method: .get,
                   parameters: params,
                   encoding: URLEncoding.queryString)
        .responseData { response in
            switch response.result {
            case .success(let value):
                do {
                    if let dict = try JSONSerialization.jsonObject(with: value, options: []) as? [String:Any]{
                        if let _response = Mapper<Response>(shouldIncludeNilValues: false).map(JSONObject: dict), _response.articles.count > 0 {
                            RealmService.shared.saveArticleList(articles: _response.articles)
                            completion(_response.articles,true)
                        }else{
                            
                            completion(RealmService.shared.getArticleList(),true)
                        }
                    }else{
                        completion(RealmService.shared.getArticleList(),false)
                    }
                } catch {
                    completion(RealmService.shared.getArticleList(),false)
                }
                break
            case .failure(_):
                completion(RealmService.shared.getArticleList(),false)
                break
            }
        }
    }
}

class RealmService{
    static let shared = RealmService()
    private let database: Realm
    private init() {
        self.database = try! Realm()
    }

    func saveArticleList(articles:[Article]) {
        deleteArticleList()
        let articleRealmModel = articles.map {
            let model = ArticleRealmModel()
            model.title = $0.title
            model.publishedAt = $0.publishedAt
            model.url = $0.url
            model.urlToImage = $0.urlToImage
            return model
        }
        
        try? database.write {
            database.add(articleRealmModel, update: .modified)
        }
    }
    
    func deleteArticleList() {
        let del = database.objects(ArticleRealmModel.self)
        try? database.write{
            database.delete(del)
        }
    }
    
    func getArticleList() -> [Article] {
        let articles = database.objects(ArticleRealmModel.self).compactMap {
            var dict:[String:Any] = [:]
            dict["title"] = $0.title
            dict["url"] = $0.url
            dict["publishedAt"] = $0.publishedAt
            dict["urlToImage"] = $0.urlToImage
            return Article(JSON: dict)
        }
        return Array(articles)
    }
    
    func setReadArticle(title:String) {
        let model = ArticleInfoRealmModel()
        let data = title.data (using: .utf8)
        if let encode = data?.base64EncodedString() {
            model.title = encode
            model.isReaded = true
            try? database.write{
                database.add(model, update: .modified)
            }
        }
    }
    
    func getReadArticle(title:String) -> Bool {
        let data = title.data (using: .utf8)
        if let encode = data?.base64EncodedString() {
            let info = database.objects(ArticleInfoRealmModel.self).filter("title == '\(encode)'").first
            return info?.isReaded ?? false
        }else{
            return false
        }
    }
}
