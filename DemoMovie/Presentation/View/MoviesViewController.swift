//
//  MoviesViewController.swift
//  DemoMovie
//
//  Created by Dat Bui on 16/03/2023.
//

import UIKit
import RxSwift
import RxCocoa

class MoviesViewController: UIViewController {

    let viewModel: MoviesViewModel
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var emptyLabel: UILabel!
    @IBOutlet weak var moviesCollectionView: UICollectionView!
    
    private let disposeBag = DisposeBag()
    private var movies = [Movie]()
    
    init(viewModel: MoviesViewModel) {
        self.viewModel = viewModel
        super.init(nibName: Self.identifier, bundle: .main)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configUI()
        config()
    }
    
    private func config() {
        textField.rx.text
            .throttle(DispatchTimeInterval.seconds(1), scheduler: MainScheduler.instance)
        .distinctUntilChanged()
        .subscribe(onNext: { [weak self] element in
            guard let element = element, !element.isEmpty else { return }
            self?.viewModel.loadData(searchText: element)
        }).disposed(by: disposeBag)
        
        viewModel.dataSource.subscribe { [weak self] listMovies in
            self?.movies = listMovies
            self?.moviesCollectionView.reloadData()
        }.disposed(by: disposeBag)
        
        viewModel.showNoData.subscribe { [weak self] isEmpty in
            self?.moviesCollectionView.isHidden = isEmpty
        }.disposed(by: disposeBag)
        
    }
    
    private func configUI() {
        moviesCollectionView.dataSource = self
        moviesCollectionView.delegate = self
        moviesCollectionView.register(UINib(nibName: MovieCell.identifier, bundle: .main), forCellWithReuseIdentifier: MovieCell.identifier)
    }

}

extension MoviesViewController: UICollectionViewDataSource, UICollectionViewDelegate,
                                    UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieCell.identifier, for: indexPath) as! MovieCell
        cell.config(movies[indexPath.item])
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (UIScreen.main.bounds.width - 10) / 2
        return CGSize(width: width, height: width)
    }
}

