//
//  MovieFactory.swift
//  MovieChallenge
//
//  Created by Tequilan on 13/07/2022.
//

class MovieFactory {
    var movieList = [MovieModel]()
    var currentPage = 1
    var noMoreRecord = false
    
    func searchMovie(keyWord: String!, refresh: Bool = true, completion: @escaping ViewCompletionHander) {
        if refresh {
            currentPage = 1
            movieList.removeAll()
        }
        var list = [MovieModel]()
        CoreAPI.Movie.searchMovies(keyWord: keyWord, page: currentPage) {[unowned self] json, backendResponse in
            if backendResponse.isSucceed {
                if let movies = json["Search"].array {
                    for mJson in movies {
                        list.append(MovieModel(json: mJson))
                    }
                    self.movieList.append(contentsOf: list)
                    self.currentPage += 1
                    self.noMoreRecord = false
                } else {
                    // No record found
                    // OR no more record
                    self.noMoreRecord = true
                }
            }
            completion(backendResponse.isSucceed, backendResponse.message)
        }
    }
    
    func clearMovies() {
        movieList.removeAll()
        currentPage = 1
        noMoreRecord = false
    }
    
    func cancelSearchingMovies() {
        CoreAPI.Movie.cancelSearchingMovies()
    }
}
