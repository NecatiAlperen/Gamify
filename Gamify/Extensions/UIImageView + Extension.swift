//
//  UIImageView + Ext.swift
//  Gamify
//
//  Created by Necati Alperen IŞIK on 24.05.2024.
//

import UIKit
import Kingfisher

extension UIImageView {
    func loadImage(from url: String?) {
        guard let urlString = url, let url = URL(string: urlString) else {
            self.image = UIImage(named: "1")
            return
        }
        self.kf.setImage(with: url)
    }
}
