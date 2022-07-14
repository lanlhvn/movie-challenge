//
//  CoreAPI+Movie.swift
//  MovieChallenge
//
//  Created by Tequilan on 13/07/2022.
//

extension CoreAPI {
    struct Movie {
        static func searchMovies(keyWord: String!, page: Int = 1, completion: @escaping NetworkingCompletion) {
            let endpoint = String(format: Endpoints.SearchMovieEndpoint, keyWord, page)
            CoreAPI.makeRequest(endPoint: endpoint, method: .get, completion: completion)
        }
    }
}
