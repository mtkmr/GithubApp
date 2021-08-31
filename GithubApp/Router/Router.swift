//
//  Router.swift
//  GithubApp
//
//  Created by Masato Takamura on 2021/08/29.
//

import UIKit
import SafariServices


final class Router {
    static let shared = Router()
    private init() {}
    
    private var window: UIWindow?
    
    func showRoot(window: UIWindow?) {
        let searchVC = SearchViewController()
        let presenter = SearchPresenter(output: searchVC)
        searchVC.inject(presenter: presenter)
        window?.rootViewController = UINavigationController(rootViewController: searchVC)
        window?.makeKeyAndVisible()
        self.window = window
    }
    
    func showSafari(from: UIViewController, urlString: String) {
        guard let url = URL(string: urlString) else { return }
        let safariVC = SFSafariViewController(url: url)
        safariVC.modalPresentationStyle = .fullScreen
        safariVC.preferredControlTintColor = .label
        safariVC.dismissButtonStyle = .close
        from.present(safariVC, animated: true, completion: nil)
    }
}
