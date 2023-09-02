//
//  SearchViewController.swift
//  Movies
//
//  Created by Sendo Tjiam on 01/09/23.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class SearchViewController: UIViewController {
    
    private enum HomeSectionType {
        case loading, list
    }
    private lazy var collectionView = makeCollectionView()
    
    private lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.searchBarStyle = .minimal
        searchBar.placeholder = " Search..."
        searchBar.sizeToFit()
        searchBar.isTranslucent = false
        return searchBar
    }()
    
    private let sections : [HomeSectionType] = [
        .list, .loading
    ]
    
    private let viewModel: SearchViewModelProtocol
    private let bag = DisposeBag()
    
    private var keyword = ""
    
    init(with viewModel: SearchViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupBindings()
    }
    
}

extension SearchViewController {
    private func setupViews() {
        title = "Search"
        view.backgroundColor = .white
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(LoadingCollectionViewCell.self, forCellWithReuseIdentifier: LoadingCollectionViewCell.identifier)
        collectionView.register(ThumbnailCollectionViewCell.self, forCellWithReuseIdentifier: ThumbnailCollectionViewCell.identifier)
        view.addSubview(searchBar)
        view.addSubview(collectionView)
        
        searchBar.snp.makeConstraints({ make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.equalToSuperview().offset(12)
            make.trailing.equalToSuperview().offset(-12)
        })
        collectionView.snp.makeConstraints({ make in
            make.top.equalTo(searchBar.snp_bottomMargin).offset(16)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.bottom.equalToSuperview()
        })
    }
    
    private func setupBindings() {
        viewModel.movieListSubject
            .subscribe({ [weak self] event in
                guard let self else { return }
                switch event {
                case .next(_):
                    self.collectionView.reload()
                case .error(let error):
                    guard let error = error as? BaseErrors else {
                        return
                    }
                    switch (error) {
                    default:
                        let alert = self.createAlert("Failed", "Failed to get movie list, please try again later.", nil)
                        self.present(alert, animated: true)
                    }
                case .completed:
                    return
                }
            }).disposed(by: bag)
        
        collectionView.rx.didScroll.subscribe({ [weak self] _ in
            guard let self = self else { return }
            let offSetY = self.collectionView.contentOffset.y
            let contentHeight = self.collectionView.contentSize.height
            
            if offSetY > (contentHeight - self.collectionView.frame.size.height - 100) {
                if !self.keyword.isEmpty && !self.viewModel.isRequestLoadMore {
                    self.viewModel.onLoadMore()
                }
            }
        }).disposed(by: bag)
        
        searchBar.rx.text.orEmpty
            .debounce(.milliseconds(2000), scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] (text) in
                self?.keyword = text
                self?.viewModel.onSearch(keyword: text)
            }).disposed(by: bag)
        
        NotificationCenter.default.addObserver(self, selector: #selector(onKeyboardWillShowNotification(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(onKeyboardWillHideNotification(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func makeCollectionView() -> UICollectionView {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 16
        layout.minimumLineSpacing = 16
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
        collectionView.backgroundColor = .clear
        collectionView.alwaysBounceVertical = true
        return collectionView
    }
    
    @objc private func onKeyboardWillHideNotification(_ notification: Notification) {
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 16, right: 0)
    }
    
    @objc private func onKeyboardWillShowNotification(_ notification: Notification) {
        guard let userInfo = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        
        let keyboardSize = userInfo.cgRectValue.size
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height - view.safeAreaInsets.bottom, right: 0)
    }
}


extension SearchViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        sections.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        switch sections[section] {
        case .list:
            return viewModel.displayData.count
        case .loading:
            return 1
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch sections[indexPath.section] {
        case .list:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ThumbnailCollectionViewCell.identifier,
                                                                for: indexPath) as? ThumbnailCollectionViewCell
            else { return UICollectionViewCell() }
            cell.configure(with: viewModel.displayData[indexPath.row])
            return cell
        case .loading:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LoadingCollectionViewCell.identifier,
                                                                for: indexPath) as? LoadingCollectionViewCell
            else { return UICollectionViewCell() }
            cell.configure()
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch sections[indexPath.section] {
        case .list:
            let width = (collectionView.frame.width / 2) - 8
            return CGSize(width: width, height: 270)
        case .loading:
            let width = (collectionView.frame.width)
            return CGSize(width: width, height: 44)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let id = viewModel.displayData[indexPath.row].id
        DetailWireframe().show(from: self, with: id)
    }
}

