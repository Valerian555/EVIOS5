//
//  ImageViewExtension.swift
//  EVALIOS5
//
//  Created by Student08 on 25/10/2023.
//

import Foundation
import UIKit
import AlamofireImage

extension UIImageView {
    func loadImage(url: String) {
        let url = URL(string: url)
        let placeholderImage = UIImage(named: "placeholder")
        self.af.setImage(withURL: url!, placeholderImage: placeholderImage)
    }
}
