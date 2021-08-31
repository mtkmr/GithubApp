//
//  SearchPresenter.swift
//  GithubApp
//
//  Created by Masato Takamura on 2021/08/30.
//

import Foundation

protocol SearchPresenterInput {
    var numberOfItemsInSection: Int { get }
    func searchedItem(indexPath: IndexPath) -> Item
    func searchData(text: String)
    func didSelectItem(at indexPath: IndexPath)
}

protocol SearchPresenterOutput: AnyObject {
    func handleError(error: GithubAPIError)
    func update(items: [Item])
    func startIndicator()
    func stopIndicator()
    func showSafari(url: String)
}

final class SearchPresenter {
    private weak var output: SearchPresenterOutput!
    private let apiClient: APIClientInput!
    
    private var items: [Item] = []
    
    init(output: SearchPresenterOutput, apiClient: APIClientInput = APIClient.shared) {
        self.output = output
        self.apiClient = apiClient
    }
}

extension SearchPresenter: SearchPresenterInput {
    
    var numberOfItemsInSection: Int {
        items.count
    }
    
    func searchedItem(indexPath: IndexPath) -> Item {
        return items[indexPath.row]
    }
    
    func searchData(text: String) {
        output.startIndicator()
        let parameter = GithubAPIParameter(searchWord: text)
        apiClient.getUserData(
            parameter: parameter,
            completion: { [weak self] result in
                self?.output.stopIndicator()
                switch result {
                case .failure(let error):
                    self?.output.handleError(error: error)
                case .success(let apiResults):
                    self?.items = apiResults.items
                    self?.output.update(items: apiResults.items)
                }
            }
        )
    }
    
    func didSelectItem(at indexPath: IndexPath) {
        let itemSelected = items[indexPath.row]
        let repositoryUrlSelected = itemSelected.repositoryUrl
        output.showSafari(url: repositoryUrlSelected)
    }
    
    
}
