//
//  MovieCell.swift
//  DemoMovie
//
//  Created by Dat Bui on 16/03/2023.
//

import UIKit
import SDWebImage

class MovieCell: UICollectionViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var thumbnail: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func config(_ model: Movie) {
        titleLabel.text = model.title
        if let url = URL(string: model.poster) {
            thumbnail.sd_setImage(with: url)
        }
    }

}
