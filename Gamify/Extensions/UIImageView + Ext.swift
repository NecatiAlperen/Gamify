//
//  UIImageView + Ext.swift
//  Gamify
//
//  Created by Necati Alperen IŞIK on 24.05.2024.
//

import UIKit

extension UIImageView {
    func loadImage(from url: String?) {
        guard let urlString = url, let url = URL(string: urlString) else {
            self.image = UIImage(named: "1")
            return
        }
        
        DispatchQueue.global().async {
            if let data = try? Data(contentsOf: url) {
                DispatchQueue.main.async {
                    self.image = UIImage(data: data)
                }
            }
        }
    }
}


