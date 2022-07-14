//
//  Constants.swift
//  movieChallenge
//
//  Created by Tequilan on 13/07/2022.
//

struct Constants {
    static let NETWORK_ERROR_CODE           = -999
    static let PAGE_SIZE                    = 10
}

struct Endpoints {
    static let SearchMovieEndpoint          = "http://www.omdbapi.com/?apikey=b9bd48a6&s=%@&type=movie&page=%d"
}
