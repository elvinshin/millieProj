//
//  RealmModel.swift
//  millieProj
//
//  Created by shin on 4/21/24.
//

import Foundation
import RealmSwift

class ArticleRealmModel :Object {
    @Persisted(primaryKey: true) var title: String = ""
    @Persisted var publishedAt: String = ""
    @Persisted var url: String = ""
    @Persisted var urlToImage: String = ""
}

class ArticleInfoRealmModel :Object {
    @Persisted(primaryKey: true) var title: String = ""
    @Persisted var isReaded: Bool = false
}
