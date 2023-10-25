//
//  StoreCollectionViewCell.swift
//  EVALIOS5
//
//  Created by Student08 on 25/10/2023.
//

import UIKit

class StoreCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var gameFinalPrice: UILabel!
    @IBOutlet weak var gameOriginalPrice: UILabel!
    @IBOutlet weak var gameDiscount: UILabel!
    @IBOutlet weak var gameName: UILabel!
    @IBOutlet weak var gameImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setup(game: WindowsGame) {
        if(game.discounted!) {
            gameName.text = game.name
            gameImage.loadImage(url: game.small_capsule_image ?? "")
            gameDiscount.text = game.discount_percent?.formatDiscount()
            let attributedText = NSAttributedString(
                string: game.original_price?.formatCentsToEuros() ?? "",
                attributes: [NSAttributedString.Key.strikethroughStyle: NSUnderlineStyle.single.rawValue]
            )
            
            gameOriginalPrice.attributedText = attributedText
            gameOriginalPrice.text = game.original_price?.formatCentsToEuros()
            gameFinalPrice.text = game.final_price?.formatCentsToEuros()
        } else {
            gameDiscount.isHidden = true
            gameOriginalPrice.isHidden = true
            
            gameName.text = game.name
            gameImage.loadImage(url: game.small_capsule_image ?? "")
            gameFinalPrice.text = game.final_price?.formatCentsToEuros()
        }
    }
}
