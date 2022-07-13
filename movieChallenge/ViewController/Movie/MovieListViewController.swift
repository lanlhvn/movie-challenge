//
//  MovieListViewController.swift
//  movieChallenge
//
//  Created by Tequilan on 13/07/2022.
//

import UIKit
import PullToRefreshKit

class MovieListViewController: BaseViewController {
    private let MOVIE_CELL_IDENTIFIER = "MovieCellIdentifier"
    private let CELL_SPACING = 15.0
    private let NUMBER_OF_ITEM_IN_A_ROW = 2
    private let THUMBNAIL_RATIO: CGFloat = 450/300 /* (height/width) */
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    lazy var searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        return searchController
    }()
    
    lazy var movieFactory: MovieFactory = {
        return MovieFactory()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        bindData()
    }
}

// MARK: - private methods
extension MovieListViewController {
    fileprivate func setupView() {
        title = "Film list"
        setupSearchController()
        setupCollectionView()
    }
    
    fileprivate func setupSearchController() {
        navigationItem.searchController = searchController
    }
    
    fileprivate func bindData() {
        loadMovies()
    }
    
    fileprivate func loadMovies(refresh: Bool = true) {
        guard let searchText = searchController.searchBar.text else { return }
        if searchController.isActive {
            Helper.showLoading()
            movieFactory.searchMovie(keyWord: searchText, refresh: refresh) { [weak self] success, message in
                Helper.dismissLoading()
                if success {
                    self?.collectionView.reloadData()
                }
            }
        }
    }
    
    fileprivate func setupCollectionView() {
        collectionView.register(UINib.init(nibName: "\(MovieCell.self)", bundle: nil), forCellWithReuseIdentifier: MOVIE_CELL_IDENTIFIER)
        let footer = DefaultRefreshFooter.footer()
        footer.setText("Load more...", mode: .refreshing)
        footer.setText("", mode: .pullToRefresh)
        footer.setText("", mode: .scrollAndTapToRefresh)
        footer.setText("", mode: .noMoreData)
        collectionView.configRefreshFooter(with: footer, container: self) { [weak self] in
            self?.loadMovies(refresh: false)
        }
    }
    
//    fma
}

// MARK: - UISearchResultsUpdating
extension MovieListViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        loadMovies()
    }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource 
extension MovieListViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movieFactory.movieList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MOVIE_CELL_IDENTIFIER, for: indexPath) as! MovieCell
        cell.setupCell(model: movieFactory.movieList[indexPath.row])
        DispatchQueue.main.async {
            cell.setNeedsLayout()
            cell.layoutIfNeeded()
        }
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension MovieListViewController: UICollectionViewDelegateFlowLayout {    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let layout = collectionViewLayout as! UICollectionViewFlowLayout
        let totalMargin = layout.sectionInset.left
        + layout.sectionInset.right
        + (layout.minimumInteritemSpacing * CGFloat(NUMBER_OF_ITEM_IN_A_ROW - 1))
        let width = (collectionView.bounds.width - totalMargin) / CGFloat(NUMBER_OF_ITEM_IN_A_ROW)
        let height = width * THUMBNAIL_RATIO
        print("cell size: \(CGSize(width: width, height: height))")
        return CGSize(width: width, height: height)
    }
}
