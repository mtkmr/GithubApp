//
//  UIImage+.swift
//  GithubApp
//
//  Created by Masato Takamura on 2021/08/29.
//

import UIKit

extension UIImage {
    convenience init(url: String) {
        guard let url = URL(string: url),
              let data = try? Data(contentsOf: url)
        else {
            self.init()
            return
        }
        self.init(data: data)!
    }
}
