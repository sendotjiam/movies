//
//  HomeViewController.swift
//  Movies
//
//  Created by Sendo Tjiam on 01/09/23.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class HomeViewController: UIViewController {
    
    private enum HomeSectionType {
        case loading, list
    }
    
    private lazy var collectionView = makeCollectionView()
    
    private lazy var loadingIndicatorView = {
        let view = LoadingView(frame: CGRect(x: 0, y: 0, width: 60, height: 60))
        view.backgroundColor = .black.withAlphaComponent(0.5)
        view.isHidden = true
        view.roundCorner(with: 10)
        return view
    }()
    
    private lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.searchBarStyle = .minimal
        searchBar.placeholder = " Search..."
        searchBar.sizeToFit()
        searchBar.isTranslucent = false
        searchBar.isUserInteractionEnabled = false
        return searchBar
    }()
    
    private lazy var searchView: UIView = {
        let view = UIView(frame: .zero)
        view.addSubview(searchBar)
        view.backgroundColor = .clear
        searchBar.snp.makeConstraints({ make in
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
        })
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapSearch))
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(tapGesture)
        return view
    }()
    
    private let sections : [HomeSectionType] = [
        .list, .loading
    ]
    
    private let viewModel: HomeViewModelProtocol
    private let bag = DisposeBag()
    
    init(with viewModel: HomeViewModelProtocol) {
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
        viewModel.onViewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        title = "Popular Movies"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        
        let favoriteButton = UIBarButtonItem(title: "Favorites", style: .plain, target: self, action: #selector(didTapFavorite))
        navigationItem.rightBarButtonItem = favoriteButton
    }
}

extension HomeViewController {
    private func setupViews() {
        view.backgroundColor = .white
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(LoadingCollectionViewCell.self, forCellWithReuseIdentifier: LoadingCollectionViewCell.identifier)
        collectionView.register(ThumbnailCollectionViewCell.self, forCellWithReuseIdentifier: ThumbnailCollectionViewCell.identifier)
        
        view.addSubview(searchView)
        view.addSubview(collectionView)
        view.addSubview(loadingIndicatorView)
        searchView.snp.makeConstraints({ make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.equalToSuperview().offset(12)
            make.trailing.equalToSuperview().offset(-12)
        })
        collectionView.snp.makeConstraints({ make in
            make.top.equalTo(searchView.snp_bottomMargin).offset(16)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.bottom.equalToSuperview()
        })
        loadingIndicatorView.snp.makeConstraints({ make in
            make.center.equalToSuperview()
            make.width.equalTo(60)
            make.height.equalTo(60)
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
        
        viewModel.showInitialLoadingSubject
            .asObservable()
            .observe(on: MainScheduler.instance)
            .bind(onNext: { [weak self] isLoading in
                guard let self else { return }
                self.loadingIndicatorView.isLoading = isLoading
                self.loadingIndicatorView.isHidden = !isLoading
                self.view.isUserInteractionEnabled = !isLoading
            })
            .disposed(by: bag)
        
        collectionView.rx.didScroll.subscribe({ [weak self] _ in
            guard let self = self else { return }
            let offSetY = self.collectionView.contentOffset.y
            let contentHeight = self.collectionView.contentSize.height
            
            if offSetY > (contentHeight - self.collectionView.frame.size.height - 100) {
                if !self.viewModel.isRequestLoadMore {
                    self.viewModel.onLoadMore()
                }
            }
        }).disposed(by: bag)
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
    
    @objc private func didTapSearch() {
        SearchWireframe().show(from: self)
    }
    
    @objc private func didTapFavorite() {
        FavoritesWireframe().show(from: self)
    }
}


extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
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
