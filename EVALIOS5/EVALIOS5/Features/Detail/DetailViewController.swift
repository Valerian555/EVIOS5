//
//  DetailViewController.swift
//  EVALIOS5
//
//  Created by Student08 on 25/10/2023.
//

import UIKit
import SafariServices

class DetailViewController: UIViewController {
    
    @IBOutlet weak var macView: UIView!
    @IBOutlet weak var linuxView: UIView!
    @IBOutlet weak var windowsView: UIView!
    @IBOutlet weak var gameImage: UIImageView!
    @IBOutlet weak var gameName: UILabel!
    @IBOutlet weak var addToWishListButton: UIButton!
    @IBOutlet weak var moreInfoButton: UIButton!
    @IBOutlet weak var originalPrice: UILabel!
    @IBOutlet weak var finalprice: UILabel!
    @IBOutlet weak var discount: UILabel!
    @IBOutlet weak var gameControllerImage: UIImageView!
    var game: Game?
    var isInFavorite = false
    
    //MARK: View Lyfecyle
    override func viewDidLoad() {
        super.viewDidLoad()
    
        setupView()
        
        addToWishListButton.layer.cornerRadius = 5
        moreInfoButton.layer.cornerRadius = 5
        
        if(game?.controllerSupport ?? "" == "full") {
            gameControllerImage.isHidden = false
        }

    }
    
    override func viewWillAppear(_ animated: Bool) {
        isInFavorite = DataManager.shared.isInFavorite(favoriteId: game?.id ?? 0)
        setupWishlistButton(isInFavorite: isInFavorite)
    }
    
    //MARK: Setup
    func setupView() {
        gameName.text = game?.name
        gameImage.loadImage(url: game?.largeImage ?? "")
        setupPrice()
        setupAvailability()
    }
    
    func setupWishlistButton(isInFavorite: Bool) {
        if(isInFavorite) {
            addToWishListButton.setTitle("Ajouté", for: .normal)
            addToWishListButton.setImage(UIImage(systemName: "checkmark"), for: .normal)
        } else {
            addToWishListButton.setTitle("Ajouter à ma wishlist", for: .normal)
            addToWishListButton.setImage(UIImage(systemName: "plus"), for: .normal)
        }
    }
    
    func setupPrice() {
        if(game?.discounted ?? false) {
            finalprice.text = game?.finalPrice?.formatCentsToEuros()
            discount.text = game?.discountPercent?.formatDiscount()
            let attributedText = NSAttributedString(
                string: game?.originalPrice?.formatCentsToEuros() ?? "",
                attributes: [NSAttributedString.Key.strikethroughStyle: NSUnderlineStyle.single.rawValue]
            )
            
            originalPrice.attributedText = attributedText
        } else {
            finalprice.text = game?.originalPrice?.formatCentsToEuros()
            discount.isHidden = true
            originalPrice.isHidden = true
        }
        
        if(game?.finalPrice == 0) {
            finalprice.text = "Free"
        }
    }
    
    func setupAvailability() {
        if let game = game {
            if game.linuxAvailable! {
                linuxView.isHidden = false
            } else {
                linuxView.isHidden = true
            }
            
            if game.macAvailable! {
                macView.isHidden = false
            } else {
                macView.isHidden = true
            }
            
            if game.windowsAvailable! {
                windowsView.isHidden = false
            } else {
                windowsView.isHidden = true
            }
        } else {
            linuxView.isHidden = true
            macView.isHidden = true
            windowsView.isHidden = true
        }
    }
    
    
    //MARK: - Actions
    @IBAction func didTapMoreInfoButton(_ sender: Any) {
        let safariUrl = "https://store.steampowered.com/app/\(game?.id ?? 0)"
        //ouverture du safariController
        if let url = URL(string: safariUrl) {
            let vc = SFSafariViewController (url: url)
            present(vc, animated: true)
        }
    }
    
    @IBAction func DidTapToWishlistButton(_ sender: Any) {
        if(isInFavorite) {
            isInFavorite = false
            DataManager.shared.deleteFavoriteById(id: game?.id ?? 0)
            setupWishlistButton(isInFavorite: isInFavorite)
        } else {
            isInFavorite = true
            DataManager.shared.addFavorite(id: game?.id ?? 0, name: game?.name ?? "", addedDate: Date())
            setupWishlistButton(isInFavorite: isInFavorite)
        }
    }
}
