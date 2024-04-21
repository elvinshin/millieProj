//
//  ViewController.swift
//  millieProj
//
//  Created by shin on 4/20/24.
//

import UIKit
import RxSwift
import SnapKit

class ViewController: UIViewController {
    var viewModel = ViewModel()
    lazy var collectionView: UICollectionView = {
        let cv = UICollectionView(frame: CGRect.zero, collectionViewLayout: generateLayout())
        cv.register(ArticleCell.self, forCellWithReuseIdentifier: String(describing: ArticleCell.self))
        cv.backgroundColor = .white
        return cv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addView()
        attribute()
        setLayout()
        bind()
        // Do any additional setup after loading the view.
    }
    
    func addView() {
        view.addSubview(collectionView)
    }
    
    func attribute() {
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    func setLayout() {
        collectionView.snp.makeConstraints {
            $0.leading.top.bottom.trailing.equalToSuperview()
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        collectionView.reloadData()
    }
    
    private func generateLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10
        return layout
    }
    override func viewWillTransition(to size: CGSize, with coordinator: any UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.invalidateLayout()
        }
        
    }
    
    func bind() {
        viewModel.getArticleList {[weak self] in
            guard let weakSelf = self else { return }
            weakSelf.collectionView.reloadData()
        }
    }
}

extension ViewController:UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
              else { return CGSize(width: UIScreen.main.bounds.width - 40, height: 120) }
        return windowScene.interfaceOrientation.isPortrait ? CGSize(width: UIScreen.main.bounds.width - 40, height: 120):CGSize(width: (UIScreen.main.bounds.width - 40 - 20)/3, height: 120)
    }
}

extension ViewController:UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.articles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: ArticleCell.self), for: indexPath) as! ArticleCell
        let article = viewModel.getArticle(index: indexPath.item)
        cell.setData(article: article)
        return cell
    }
}

extension ViewController:UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let url = viewModel.getArticle(index: indexPath.item).url
        let title = viewModel.getArticle(index: indexPath.item).title
        guard let webVC = WkWebViewController.showWebView(urlString: url, title:title) else { return }
        RealmService.shared.setReadArticle(title: title)
        navigationController?.pushViewController(webVC, animated: true)
    }
}
