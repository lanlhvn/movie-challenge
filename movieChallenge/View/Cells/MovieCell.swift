//
//  MovieCell.swift
//  MovieChallenge
//
//  Created by Tequilan on 13/07/2022.
//

import UIKit
import SDWebImage

class MovieCell: UICollectionViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var posterImageView: UIImageView!
    
    func setupCell(model: MovieModel) {
        titleLabel.text = model.title
        if let poster = model.poster,
           let posterUrl = URL(string: poster) {
            posterImageView.sd_setImage(with: posterUrl)
        }
    }
}
