//
//  WKWebViewController.swift
//  millieProj
//
//  Created by shin on 4/20/24.
//

import UIKit

import WebKit
import Then
import SnapKit

class WkWebViewController: UIViewController {
    
    var wkWebView:WKWebView = WKWebView()
    var urlRequest:URLRequest?
    
    init(request: URLRequest, title:String) {
        super.init(nibName: nil, bundle: nil)
        self.urlRequest = request
        self.title = title
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        attribute()
        layout()
    }
    
    func attribute(){
        guard let request = urlRequest else { return }
        wkWebView.load(request)
    }
    
    func layout(){
        view.addSubview(wkWebView)
        wkWebView.snp.makeConstraints {
            $0.top.left.right.bottom.equalToSuperview()
        }
    }
}

extension WkWebViewController{
    class func showWebView(urlString:String, title:String) -> UIViewController?{
        guard let request = URL(string: urlString) else { return nil }
        let urlRequest = URLRequest(url: request)
        let webViewController = WkWebViewController(request: urlRequest, title: title)
        return webViewController
    }
}

