//
//  StoreCollectionViewCell.swift
//  EVALIOS5
//
//  Created by Student08 on 25/10/2023.
//

import UIKit

class StoreCollectionViewCell: UICollectionViewCell {
    
    //MARK: - Properties
    @IBOutlet weak var gameFinalPrice: UILabel!
    @IBOutlet weak var gameOriginalPrice: UILabel!
    @IBOutlet weak var gameDiscount: UILabel!
    @IBOutlet weak var gameName: UILabel!
    @IBOutlet weak var gameImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    //MARK: - Setup
    func setup(game: Game) {
        if(game.discounted!) {
            gameName.text = game.name
            gameImage.loadImage(url: game.smallImage ?? "")
            gameDiscount.text = game.discountPercent?.formatDiscount()
            let attributedText = NSAttributedString(
                string: game.originalPrice?.formatCentsToEuros(currency: game.currency ?? "EUR") ?? "",
                attributes: [NSAttributedString.Key.strikethroughStyle: NSUnderlineStyle.single.rawValue]
            )
            
            gameOriginalPrice.attributedText = attributedText
            gameOriginalPrice.text = game.originalPrice?.formatCentsToEuros(currency: game.currency ?? "EUR")
            gameFinalPrice.text = game.finalPrice?.formatCentsToEuros(currency: game.currency ?? "EUR")
        } else {
            gameDiscount.isHidden = true
            gameOriginalPrice.isHidden = true
            
            gameName.text = game.name
            gameImage.loadImage(url: game.smallImage ?? "")
            gameFinalPrice.text = game.finalPrice?.formatCentsToEuros(currency: game.currency ?? "EUR")
        }
        
        if(game.finalPrice == 0) {
            gameFinalPrice.text = "Free"
        }
    }
}
