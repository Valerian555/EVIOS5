//
//  ViewController.swift
//  EVALIOS5
//
//  Created by Student08 on 25/10/2023.
//

import UIKit
import Alamofire

class StoreViewController: UIViewController {
    
    @IBOutlet weak var storeCollectionView: UICollectionView!
    var games = [WindowsGame]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Store"
        
        loadGames()
        
        storeCollectionView.delegate = self
        storeCollectionView.dataSource = self
        
        storeCollectionView.register(UINib(nibName: "StoreCollectionViewCell", bundle: nil),
                                     forCellWithReuseIdentifier: "StoreCollectionViewCell")
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let numberOfColumns: CGFloat = 2
        let interitemSpacing: CGFloat = 10 // Espace horizontal entre les cellules

        // Calcul de la largeur des cellules en prenant en compte l'espace entre les cellules
        let itemWidth = (storeCollectionView.frame.size.width - (numberOfColumns - 1) * interitemSpacing) / numberOfColumns

        layout.itemSize = CGSize(width: itemWidth, height: itemWidth / 1.5)

        layout.minimumInteritemSpacing = interitemSpacing // Espace horizontal entre les cellules
        layout.minimumLineSpacing = 1 // Espace vertical entre les cellules
        storeCollectionView.collectionViewLayout = layout

        
    }
    
    func loadGames() {
        let baseUrl = "https://store.steampowered.com/api/featured"
        AF.request(baseUrl).response { response in
            switch response.result {
                
            case.success(let data):
                guard let data else { return }
                let decoder = JSONDecoder()
                
                do {
                    let gameResponse = try decoder.decode(GameResponse.self, from: data)
                    self.games = gameResponse.featured_win
                    self.storeCollectionView.reloadData()
                } catch {
                    print("Error, can't parse JSON.")
                }
                
            case.failure(let error): print("Error, can't download. (error = \(error)")
            }
        }
    }
}

extension StoreViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        games.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let customCell = collectionView.dequeueReusableCell(withReuseIdentifier:
                                                                "StoreCollectionViewCell", for: indexPath) as! StoreCollectionViewCell
        
        customCell.setup(game: games[indexPath.row])
        
        return customCell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detailViewController = storyboard?.instantiateViewController(identifier: "DetailViewController") as! DetailViewController
        
        detailViewController.game = games[indexPath.row]
        
        navigationController?.pushViewController(detailViewController, animated: true)
    }
}
