//
//  StudentTableViewCell.swift
//  ResuMe
//
//  Created by Alex Chan on 10/8/17.
//  Copyright © 2017 HAP. All rights reserved.
//

import UIKit
import FontAwesomeKit

class StudentTableViewCell: UITableViewCell {
    let iconImage = FAKFontAwesome.starIcon(withSize: 15).image(with: CGSize(width: 15, height: 15))
    let nostar = FAKFontAwesome.starOIcon(withSize: 15).image(with: CGSize(width: 15, height: 15))
    @IBOutlet weak var favorite: UIButton!
    @IBOutlet weak var name: UILabel!
    var isFav: Bool = false;
    
    override func awakeFromNib() {
        super.awakeFromNib()

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func didFavorite(_ sender: UIButton) {
        if isFav {
            favorite.setImage(iconImage, for: [])
            isFav = false
        } else {
            favorite.setImage(nostar, for: [])
            isFav = true

        }
    }
}
