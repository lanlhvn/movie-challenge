//
//  CoreAPI+Movie.swift
//  MovieChallenge
//
//  Created by Tequilan on 13/07/2022.
//

import Alamofire

extension CoreAPI {
    struct Movie {
        static func searchMovies(keyWord: String!, page: Int = 1, completion: @escaping NetworkingCompletion) {
            let searchText = keyWord.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
            let endpoint = String(format: Endpoints.SearchMovieEndpoint, searchText ?? "", page)
            CoreAPI.makeRequest(endPoint: endpoint, method: .get, completion: completion)
        }
        
        static func cancelSearchingMovies() {
            let sessionManager = Alamofire.SessionManager.default
            sessionManager.session.getTasksWithCompletionHandler({ dataTasks, uploadTasks, downloadTasks in
                dataTasks.forEach {
                    if let url = $0.originalRequest?.url,
                       url.absoluteString.contains(Endpoints.SearchMovieEndpointToCancel) {
                        $0.cancel()
                        print("cancel \(url.absoluteString)")
                    }
                }
            })
        }
    }
}
