//
//  ViewModel.swift
//  millieProj
//
//  Created by shin on 4/20/24.
//

import Foundation
import RxSwift

class ViewModel{
    var articleSubject:PublishSubject<[Article]> = PublishSubject<[Article]>()
    var articles:[Article] = []
    func numberOfItems() -> Int {
        articles.count
    }
    func getArticle(index:Int) -> Article {
        return articles[index]
    }
    func getArticleList(completion:@escaping () -> Void){
        NewsService.getHeadLineArticleList(completion: {[weak self] items, isSuccess in
            guard let weakSelf = self else {
                completion()
                return
            }
            weakSelf.articles = items
            completion()
        })
    }
}
