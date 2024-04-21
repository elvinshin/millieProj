//
//  ArticleCell.swift
//  millieProj
//
//  Created by shin on 4/20/24.
//

import UIKit
import Then
import Kingfisher
class ArticleCell:UICollectionViewCell{
    var titleLabel = UILabel().then{
        $0.numberOfLines = 2
    }
    var dateLabel = UILabel()
    var imageView = UIImageView().then{
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        addView()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addView() {
        addSubview(imageView)
        addSubview(titleLabel)
        addSubview(dateLabel)
    }
    
    func layout() {
        self.backgroundColor = .lightGray
        imageView.snp.makeConstraints {
            $0.width.height.equalTo(80)
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().offset(-20)
        }
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(20)
            $0.bottom.equalTo(dateLabel.snp.top).offset(-20)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-100)
        }
        dateLabel.snp.makeConstraints {
            $0.bottom.equalToSuperview().offset(-20)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-100)
        }
    }
    
    func setData(article:Article){
        titleLabel.text = article.title
        titleLabel.textColor = RealmService.shared.getReadArticle(title: article.title) ? .red:.black
        dateLabel.text = article.publishedAt
        imageView.kf.setImage(with: URL(string: article.urlToImage)) { result in
            switch result{
            case .success(let image):
                print(image.cacheType)
                break
            default:
                break
            }
            
        }
    }
}
