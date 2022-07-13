//
//  MovieModel.swift
//  MovieChallenge
//
//  Created by Tequilan on 13/07/2022.
//

import SwiftyJSON

class MovieModel {
    var title: String?
    var poster: String?
    
    init(json: JSON) {
        title = json["Title"].stringValue
        poster = json["Poster"].stringValue
    }
}
