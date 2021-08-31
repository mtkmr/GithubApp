//
//  GithubAPIParameter.swift
//  GithubApp
//
//  Created by Masato Takamura on 2021/08/31.
//

import Foundation

struct GithubAPIParameter {
    enum Order: String {
        case desc, asc
    }
    enum Sort: String {
        case stars
    }
    
    let searchWord: String?
    private var _searchWord: String { searchWord ?? "" }
    let sort: Sort = .stars
    let order: Order = .asc
    let perPage: Int = 100
    let page: Int = 0
    
    var validation: Bool {
        !_searchWord.isEmpty && perPage <= 100 && perPage > 0
    }
    
    var queryParameter: String {
        "q=\(_searchWord)&sort=\(sort.rawValue)&order=\(order.rawValue)&per_page=\(perPage)&page=\(page)"
    }
}
