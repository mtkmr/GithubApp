//
//  SearchViewController.swift
//  GithubApp
//
//  Created by Masato Takamura on 2021/08/29.
//

import UIKit

final class SearchViewController: UIViewController {
    //MARK: - Properties
    private var searchPresenter: SearchPresenterInput!
    func inject(presenter: SearchPresenterInput) {
        self.searchPresenter = presenter
    }
    
    private lazy var searchBar: UISearchBar = {
       let searchBar = UISearchBar()
        searchBar.placeholder = "キーワードで検索"
        searchBar.showsCancelButton = false
        searchBar.sizeToFit()
        searchBar.backgroundImage = UIImage()
        searchBar.delegate = self
        return searchBar
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let margin: CGFloat = 16.0
        let cellSize: CGFloat = view.frame.size.width / 3 - 2*margin
        layout.itemSize = CGSize(width: cellSize, height: cellSize)
        layout.minimumInteritemSpacing = margin
        layout.minimumLineSpacing = margin
        layout.sectionInset = UIEdgeInsets(top: margin, left: margin, bottom: margin, right: margin)
        let collectionView = UICollectionView(frame: .zero,
                                              collectionViewLayout: layout)
        collectionView.backgroundColor = .systemBackground
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UINib(nibName: AccountCollectionViewCell.className, bundle: nil),
                                forCellWithReuseIdentifier: AccountCollectionViewCell.className)
        return collectionView
    }()
    
    private lazy var emptyView: UIView = {
       let view = UIView()
        view.backgroundColor = .secondarySystemBackground
        view.layer.cornerRadius = 10
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var emptyLabel: UILabel = {
       let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.textColor = .label
        label.backgroundColor = .clear
        label.text = "キーワードで検索すると、\nリポジトリに関連するユーザーを一覧表示します"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var indicator: UIActivityIndicatorView = {
       let indicator = UIActivityIndicatorView()
        indicator.style = .large
        indicator.color = .lightGray
        indicator.hidesWhenStopped = true
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()

    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        navigationItem.titleView = searchBar
        view.addSubview(collectionView)
        view.addSubview(emptyView)
        emptyView.addSubview(emptyLabel)
        view.addSubview(indicator)
        setupLayoutConstraint()
        updateView(isDataEmpty: true)
    }
    
}

//MARK: - Private Extension
private extension SearchViewController {
    
    func setupLayoutConstraint() {
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            indicator.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            indicator.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            emptyView.topAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.topAnchor,
                constant: 32),
            emptyView.leadingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.leadingAnchor,
                constant: 32),
            emptyView.trailingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.trailingAnchor,
                constant: -32),
            emptyView.bottomAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.bottomAnchor,
                constant: -32)
        ])
        
        NSLayoutConstraint.activate([
            emptyLabel.centerXAnchor.constraint(equalTo: emptyView.centerXAnchor),
            emptyLabel.centerYAnchor.constraint(equalTo: emptyView.centerYAnchor)
        ])
    }
    
    func updateView(isDataEmpty: Bool) {
        DispatchQueue.main.async {
            self.emptyView.isHidden = !isDataEmpty
            self.collectionView.isHidden = isDataEmpty
        }
    }
    
    func activate(searchBar: UISearchBar) {
        DispatchQueue.main.async {
            searchBar.showsCancelButton = true
        }
    }
    
    func deactivate(searchBar: UISearchBar) {
        DispatchQueue.main.async {
            searchBar.endEditing(true)
            searchBar.showsCancelButton = false
        }
    }
}

//MARK: - UISearchBarDelegate
extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        deactivate(searchBar: searchBar)
        searchPresenter.searchData(text: searchBar.text!)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        deactivate(searchBar: searchBar)
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        activate(searchBar: searchBar)
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        deactivate(searchBar: searchBar)
    }
    
}

//MARK: - UICollectionViewDelegate
extension SearchViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        searchPresenter.didSelectItem(at: indexPath)
    }
}


//MARK: - UICollectionViewDataSource
extension SearchViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        searchPresenter.numberOfItemsInSection
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AccountCollectionViewCell.className, for: indexPath) as! AccountCollectionViewCell
        let item = searchPresenter.searchedItem(indexPath: indexPath)
        cell.configure(item: item)
        
        return cell
    }
    
}

//MARK: - SearchPresenterOutput
extension SearchViewController: SearchPresenterOutput {
    
    func handleError(error: GithubAPIError) {
        updateView(isDataEmpty: true)
        DispatchQueue.main.async {
            Alert.okAlert(title: "検索エラー",
                          message: error.description,
                          on: self)
        }
    }
    
    func update(items: [Item]) {
        updateView(isDataEmpty: false)
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    
    func startIndicator() {
        DispatchQueue.main.async {
            self.indicator.startAnimating()
        }
    }
    
    func stopIndicator() {
        DispatchQueue.main.async {
            self.indicator.stopAnimating()
        }
    }
    
    func showSafari(url: String) {
        DispatchQueue.main.async {
            Router.shared.showSafari(from: self, urlString: url)
        }
    }
}
