//
//  NSObjectProtocol+.swift
//  GithubApp
//
//  Created by Masato Takamura on 2021/08/29.
//

import Foundation

extension NSObjectProtocol {
    static var className: String {
        String(describing: self)
    }
}
