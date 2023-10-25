//
//  ViewController.swift
//  EVALIOS5
//
//  Created by Student08 on 25/10/2023.
//

import UIKit
import Alamofire

class StoreViewController: UIViewController {
    
    //MARK: - Properties
    @IBOutlet weak var storeCollectionView: UICollectionView!
    var linuxGames = [Game]()
    var windowsGames = [Game]()
    var macGames = [Game]()
    var allGames = [Game]()
    
    //MARK: View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Store"
        
        loadGames()
        setupCollectionView()
        
        
    }
    
    //MARK: - Setup
    private func setupCollectionView() {
        storeCollectionView.delegate = self
        storeCollectionView.dataSource = self
        storeCollectionView.register(UINib(nibName: "StoreCollectionViewCell", bundle: nil),
                                     forCellWithReuseIdentifier: "StoreCollectionViewCell")
        
        //taille de la cellule
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let numberOfColumns: CGFloat = 2
        let interitemSpacing: CGFloat = 10
        let itemWidth = (storeCollectionView.frame.size.width - (numberOfColumns - 1) * interitemSpacing) / numberOfColumns
        layout.itemSize = CGSize(width: itemWidth, height: itemWidth * 1.5)
        layout.minimumInteritemSpacing = interitemSpacing
        layout.minimumLineSpacing = 5
        storeCollectionView.collectionViewLayout = layout
    }
    
    //MARK: - Network
    func loadGames() {
        let baseUrl = "https://store.steampowered.com/api/featured"
        AF.request(baseUrl).response { response in
            switch response.result {
                
            case.success(let data):
                guard let data else { return }
                let decoder = JSONDecoder()
                
                do {
                    let gameResponse = try decoder.decode(GameResponse.self, from: data)
                    self.linuxGames = gameResponse.featuredLinux
                    self.windowsGames = gameResponse.featuredWin
                    self.macGames = gameResponse.featuredMac
                    
                    //ajout de toutes les listes dans une seule
                    for gameList in [self.windowsGames, self.linuxGames, self.macGames] {
                        for game in gameList {
                            //vérifier si un jeu n'est pas déjà dans la liste
                            if !self.allGames.contains(where: { $0.id == game.id }) {
                                self.allGames.append(game)
                            }
                        }
                    }
                    
                    self.storeCollectionView.reloadData()
                } catch {
                    print("Error, can't parse JSON.")
                }
                
            case.failure(let error): print("Error, can't download. (error = \(error)")
            }
        }
    }
}

//MARK: - CollectionView Extension
extension StoreViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        allGames.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let customCell = collectionView.dequeueReusableCell(withReuseIdentifier:
                                                                "StoreCollectionViewCell", for: indexPath) as! StoreCollectionViewCell
        
        customCell.setup(game: allGames[indexPath.row])
        
        return customCell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //navigation vers les détails
        let detailViewController = storyboard?.instantiateViewController(identifier: "DetailViewController") as! DetailViewController
        
        //passage de paramètre
        detailViewController.game = allGames[indexPath.row]
        
        navigationController?.pushViewController(detailViewController, animated: true)
    }
}
