//
//  MovieFactory.swift
//  MovieChallenge
//
//  Created by Tequilan on 13/07/2022.
//

class MovieFactory {
    var movieList = [MovieModel]()
    var currentPage = 1
    var noMoreRecord = true
    
    func searchMovie(keyWord: String!, refresh: Bool = true, completion: @escaping ViewCompletionHander) {
        if refresh {
            currentPage = 1
            movieList.removeAll()
        }
        var list = [MovieModel]()
        CoreAPI.Movie.searchMovies(keyWord: keyWord, page: currentPage) {json, backendResponse in
            if backendResponse.isSucceed {
                if let movies = json["Search"].array {
                    for mJson in movies {
                        list.append(MovieModel(json: mJson))
                    }
                    self.movieList.append(contentsOf: list)
                    self.currentPage += 1
                    self.noMoreRecord = false
                } else {
                    if self.currentPage == 1 {
                        // No record found
                        self.movieList.removeAll()
                    }
                    self.noMoreRecord = true
                }
            }
            completion(backendResponse.isSucceed, backendResponse.message)
        }
    }
    
    fileprivate func clearMovies() {
        movieList.removeAll()
        currentPage = 1
        noMoreRecord = true
    }
    
    func cancelSearchingMovies() {
        CoreAPI.Movie.cancelSearchingMovies()
        clearMovies()
    }
}
