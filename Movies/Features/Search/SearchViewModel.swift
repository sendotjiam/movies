//
//  SearchViewModel.swift
//  Movies
//
//  Created by Sendo Tjiam on 01/09/23.
//

import Foundation
import RxSwift
import RxRelay

final class SearchViewModel {
    var isRequestLoadMore = false
    var loadingSubject = BehaviorRelay<Bool>(value: false)
    var movieListSubject = PublishSubject<Void>()
    
    var displayData = [Movie]()
    
    private var keyword = ""
    private var currentPage = 1
    
    private let useCase: SearchMovieListUseCaseProtocol
    private let bag = DisposeBag()
    
    init(with useCase: SearchMovieListUseCaseProtocol = SearchMovieListUseCase()) {
        self.useCase = useCase
    }
}

extension SearchViewModel: SearchViewModelProtocol {
    func onSearch(keyword: String) {
        if (self.keyword != keyword) {
            reset()
        }
        self.keyword = keyword
        searchMovieList()
    }
    
    func onLoadMore() {
        isRequestLoadMore = true
        currentPage += 1
        searchMovieList()
    }
}

extension SearchViewModel {
    private func searchMovieList() {
        useCase.execute(keyword: keyword, page: currentPage).subscribe({ [weak self] event in
            guard let self = self else { return }
            switch event {
            case .next(let models):
                self.displayData.append(contentsOf: models)
                self.movieListSubject.onNext(())
            case .error(let error):
                self.movieListSubject.onError(error)
            case .completed: return
            }
            self.isRequestLoadMore = false
        }).disposed(by: bag)
    }
    
    private func reset() {
        currentPage = 1
        displayData = []
    }
}
