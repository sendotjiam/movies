//
//  HomeViewModel.swift
//  Movies
//
//  Created by Sendo Tjiam on 01/09/23.
//

import Foundation
import RxSwift
import RxRelay

final class HomeViewModel {
    
    var isRequestLoadMore = false
    var showInitialLoadingSubject = BehaviorRelay<Bool>(value: false)
    var movieListSubject = PublishSubject<Void>()
    
    var displayData = [Movie]()
    
    private let useCase: FetchMovieListUseCaseProtocol
    private let bag = DisposeBag()
    
    private var currentPage: Int = 1
    
    init(with useCase: FetchMovieListUseCaseProtocol = FetchMovieListUseCase()) {
        self.useCase = useCase
    }
    
}

extension HomeViewModel: HomeViewModelProtocol {
    func onViewDidLoad() {
        showInitialLoadingSubject.accept(true)
        fetchMovieList()
    }
    
    func onLoadMore() {
        isRequestLoadMore = true
        currentPage += 1
        fetchMovieList()
    }
}

extension HomeViewModel {
    func fetchMovieList() {
        useCase.execute(page: currentPage).subscribe({ [weak self] event in
            guard let self = self else { return }
            switch event {
            case .next(let models):
                self.displayData.append(contentsOf: models)
                self.movieListSubject.onNext(())
            case .error(let error):
                self.movieListSubject.onError(error)
            case .completed: return
            }
            self.showInitialLoadingSubject.accept(false)
            self.isRequestLoadMore = false
        }).disposed(by: bag)
    }
}
