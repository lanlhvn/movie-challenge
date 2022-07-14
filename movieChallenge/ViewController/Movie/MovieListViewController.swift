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
    private let NUMBER_OF_ITEM_IN_A_ROW_PORTRAIT = 2
    private let NUMBER_OF_ITEM_IN_A_ROW_LANDSCAPE = 4
    private let THUMBNAIL_RATIO: CGFloat = 450/300 /* (height/width) */
    
    @IBOutlet weak var collectionView: UICollectionView!
    var searchTask: DispatchWorkItem?
    
    lazy var searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Type something here to search"
        searchController.searchBar.delegate = self
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
        setProfileBarButton()
        visibleFooter()
    }
    
    fileprivate func setupSearchController() {
        navigationItem.searchController = searchController
    }
    
    fileprivate func bindData() {
        loadMovies()
    }
    
    @objc fileprivate func loadMovies(refresh: Bool = true) {
        guard let searchText = searchController.searchBar.text?.trimmingCharacters(in: .whitespaces) else { return }
        if searchController.isActive {
            if !searchText.isEmpty {
                Helper.showLoading()
                movieFactory.searchMovie(keyWord: searchText, refresh: refresh) { [weak self] success, message in
                    Helper.dismissLoading()
                    if success {
                        DispatchQueue.main.async {
                            self?.collectionView.reloadData()
                            self?.visibleFooter()
                        }
                    }
                }
            } else {
                cancelSearching()
            }
        }
    }
    
    fileprivate func cancelSearching() {
        DispatchQueue.main.async { [weak self] in
            self?.movieFactory.cancelSearchingMovies()
            self?.collectionView.reloadData()
            self?.visibleFooter()
            self?.collectionView.setContentOffset(CGPoint(x: 0, y: -54), animated: false)
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
    
    fileprivate func visibleFooter() {
        if movieFactory.noMoreRecord {
            collectionView.switchRefreshFooter(to: .noMoreData)
        } else {
            collectionView.switchRefreshFooter(to: .normal)
        }
    }
}

// MARK: - UISearchResultsUpdating
extension MovieListViewController: UISearchResultsUpdating, UISearchBarDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        // Cancel previous task if any
        searchTask?.cancel()
        cancelSearching()

        // Replace previous task with a new one
        let task = DispatchWorkItem { [weak self] in
            self?.loadMovies()
        }
        searchTask = task

        // Execute task in 0.3 seconds (if not cancelled !)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.3, execute: task)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        cancelSearching()
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
        var numberItemInARow = NUMBER_OF_ITEM_IN_A_ROW_PORTRAIT
        if UIDevice.current.orientation.isLandscape {
            numberItemInARow = NUMBER_OF_ITEM_IN_A_ROW_LANDSCAPE
        } else {
            numberItemInARow = NUMBER_OF_ITEM_IN_A_ROW_PORTRAIT
        }
        let totalMargin = layout.sectionInset.left
                        + layout.sectionInset.right
                        + (layout.minimumInteritemSpacing * CGFloat(numberItemInARow - 1))
        let width = (collectionView.bounds.width - totalMargin) / CGFloat(numberItemInARow)
        let height = width * THUMBNAIL_RATIO
        return CGSize(width: width, height: height)
    }
}

// MARK: - ScrollView
extension MovieListViewController {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if movieFactory.movieList.count > 0 {
            searchController.searchBar.resignFirstResponder()
        }
    }
}
