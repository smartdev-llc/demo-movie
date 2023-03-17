//
//  MoviesViewModel.swift
//  DemoMovie
//
//  Created by Dat Bui on 16/03/2023.
//

import Foundation
import RxSwift
import RxRelay

protocol MoviesViewModel {
    var dataSource: PublishSubject<([Movie])> { get }
    var showNoData: BehaviorRelay<Bool> { get set }
    
    func loadData(searchText: String)
}

final class ImplMoviesViewModel: MoviesViewModel {
    
    var dataSource = PublishSubject<([Movie])>()
    var showNoData = BehaviorRelay<Bool>(value: false)
    
    private let useCase: FetchMoviesUseCase
    
    init(useCase: FetchMoviesUseCase) {
        self.useCase = useCase
    }
}

extension ImplMoviesViewModel {
    func loadData(searchText: String) {
        useCase.execute(query: searchText) { [weak self] result in
            switch result {
            case .success(let list):
                self?.dataSource.onNext(list)
                self?.showNoData.accept(false)
            case .failure:
                self?.dataSource.onNext([])
                self?.showNoData.accept(true)
            }
        }
    }
}
