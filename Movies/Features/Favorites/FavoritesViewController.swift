//
//  FavoritesViewController.swift
//  Movies
//
//  Created by Sendo Tjiam on 01/09/23.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class FavoritesViewController: UIViewController {
    
    private lazy var collectionView = makeCollectionView()
    
    private lazy var loadingIndicatorView = {
        let view = LoadingView(frame: CGRect(x: 0, y: 0, width: 60, height: 60))
        view.backgroundColor = .black.withAlphaComponent(0.5)
        view.isHidden = true
        view.roundCorner(with: 10)
        return view
    }()
    
    private lazy var emptyView = {
        let view = EmptyView()
        view.isHidden = true
        return view
    }()
    
    private let wireframe = FavoritesWireframe()
    private let viewModel: FavoritesViewModelProtocol
    private let bag = DisposeBag()
    
    init(with viewModel: FavoritesViewModelProtocol) {
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
        title = "My Favorites"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
    }
}

extension FavoritesViewController {
    private func setupViews() {
        view.backgroundColor = .white
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.register(ThumbnailCollectionViewCell.self, forCellWithReuseIdentifier: ThumbnailCollectionViewCell.identifier)
        
        view.addSubview(emptyView)
        view.addSubview(collectionView)
        view.addSubview(loadingIndicatorView)
        emptyView.snp.makeConstraints({ make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        })
        collectionView.snp.makeConstraints({ make in
            make.top.equalToSuperview().offset(16)
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
                    self.emptyView.isHidden = !self.viewModel.displayData.isEmpty
                case .error(let error):
                    guard let error = error as? BaseErrors else {
                        return
                    }
                    switch (error) {
                    default:
                        self.wireframe.showAlert(from: self, title: "Failed", body: "Failed to do your task, please try again later.")
                    }
                case .completed:
                    return
                }
            }).disposed(by: bag)
        
        viewModel.loadingSubject
            .asObservable()
            .observe(on: MainScheduler.instance)
            .bind(onNext: { [weak self] isLoading in
                guard let self else { return }
                self.loadingIndicatorView.isLoading = isLoading
                self.loadingIndicatorView.isHidden = !isLoading
                self.view.isUserInteractionEnabled = !isLoading
            })
            .disposed(by: bag)
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
}

extension FavoritesViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return viewModel.displayData.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ThumbnailCollectionViewCell.identifier,
                                                            for: indexPath) as? ThumbnailCollectionViewCell
        else { return UICollectionViewCell() }
        cell.configure(with: viewModel.displayData[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.frame.width / 2) - 8
        return CGSize(width: width, height: 270)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let id = viewModel.displayData[indexPath.row].id
        DetailWireframe().show(from: self, with: id, isFromFavorite: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        let identifier = "\(indexPath.row)" as NSString
        return UIContextMenuConfiguration(identifier: identifier, previewProvider: nil, actionProvider: { suggestedActions in
            let favoriteAction = UIAction(
                title: "Remove from favorites",
                image: UIImage(systemName: "trash.fill"),
                attributes: .destructive
            ) { [weak self] action in
                guard let self else { return }
                let id = self.viewModel.displayData[indexPath.row].id
                let alert = self.createConfirmationAlert(
                    "Remove from favorites?",
                    "Are you sure you are going to remove delete this category from your favorite list", { _ in
                        self.viewModel.delete(by: id)
                    })
                self.present(alert, animated: true)
            }
            return UIMenu(title: "", children: [favoriteAction])
        })
    }
}
