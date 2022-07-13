//
//  MovieFactory.swift
//  MovieChallenge
//
//  Created by Tequilan on 13/07/2022.
//

class MovieFactory {
    var movieList = [MovieModel]()
    var currentPage = 1
    
    func searchMovie(keyWord: String!, refresh: Bool = true, completion: @escaping ViewCompletionHander) {
        if refresh {
            currentPage = 1
            movieList.removeAll()
        }
        var list = [MovieModel]()
        CoreAPI.Movie.searchMovies(keyWord: keyWord, page: currentPage) {[unowned self] json, backendResponse in
            if backendResponse.isSucceed, let movies = json["Search"].array {
                for mJson in movies {
                    list.append(MovieModel(json: mJson))
                }
                self.movieList.append(contentsOf: list)
                self.currentPage += 1
            }
            completion(backendResponse.isSucceed, backendResponse.message)
        }
    }
}
