//
//  FavoriteTableViewCell.swift
//  EVALIOS5
//
//  Created by Student08 on 25/10/2023.
//

import UIKit

class FavoriteTableViewCell: UITableViewCell {

    @IBOutlet weak var gameName: UILabel!
    @IBOutlet weak var addedDate: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setup(favorite: Favorite) {
        gameName.text = favorite.name
        addedDate.text = formatDateToString(favorite.addedDate ?? Date())
    }
    
    func formatDateToString(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        let dateString = dateFormatter.string(from: date)
        return dateString
    }
}
