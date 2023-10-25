//
//  FavoriteViewController.swift
//  EVALIOS5
//
//  Created by Student08 on 25/10/2023.
//

import UIKit
import CoreData

class FavoriteViewController: UIViewController {
    
    //MARK: - Properties
    @IBOutlet weak var favoriteTableView: UITableView!
    private var resultsController: NSFetchedResultsController<Favorite>!
    
    //MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "My wishlist"
        
        tableViewSetup()
        getFromDB()
    }
    
    //MARK: - Setup
    private func tableViewSetup() {
        favoriteTableView.delegate = self
        favoriteTableView.dataSource = self
        
        favoriteTableView.register(UINib(nibName: "FavoriteTableViewCell", bundle: nil),
                                   forCellReuseIdentifier: "FavoriteTableViewCell")
    }
    
    private func getFromDB() {
        let request = Favorite.fetchRequest()
        
        //trier la tableview par date d'ajout
        request.sortDescriptors = [
            NSSortDescriptor(key: "addedDate", ascending: false)]
        
        resultsController = NSFetchedResultsController(
            fetchRequest: request,
            managedObjectContext: DataManager.shared.context,
            sectionNameKeyPath: nil,
            cacheName: nil)
        
        resultsController.delegate = self
        
        do {
            try resultsController.performFetch()
        } catch {
            print("Error fetching initial data", error)
        }
    }
}

//MARK: - TableView Extension
extension FavoriteViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        resultsController.sections?[section].numberOfObjects ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let customCell = tableView.dequeueReusableCell(withIdentifier:
                                                        "FavoriteTableViewCell", for: indexPath) as! FavoriteTableViewCell
        let favorite = resultsController.object(at: indexPath)
        
        customCell.setup(favorite: favorite)
        
        return customCell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let favorite = resultsController.object(at: indexPath)
            DataManager.shared.deleteFavorite(favorite)
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        resultsController.sections?[section].name
    }
}

//MARK: - ResultController Extension
extension FavoriteViewController: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        favoriteTableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        favoriteTableView.endUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        switch type {
        case .insert:
            favoriteTableView.insertSections([sectionIndex], with: .automatic)
        case .delete:
            favoriteTableView.deleteSections([sectionIndex], with: .automatic)
        default:
            break
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            favoriteTableView.insertRows(at: [newIndexPath!], with: .automatic)
        case .delete:
            favoriteTableView.deleteRows(at: [indexPath!], with: .automatic)
        case .move:
            favoriteTableView.deleteRows(at: [indexPath!], with: .automatic)
            favoriteTableView.insertRows(at: [newIndexPath!], with: .automatic)
        case .update:
            favoriteTableView.reloadRows(at: [indexPath!], with: .automatic)
        default:
            break
        }
    }
}
