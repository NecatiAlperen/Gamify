//
//  String + Extension.swift
//  Gamify
//
//  Created by Necati Alperen IŞIK on 26.05.2024.
//

import Foundation

extension String {
    
    func stringByRemovingHTMLTags() -> String {
        
        let regex = try! NSRegularExpression(pattern: "<[^>]+>")
        let range = NSRange(location: 0, length: self.utf16.count)
        let cleanString = regex.stringByReplacingMatches(in: self, options: [], range: range, withTemplate: "")
        return cleanString
        
    }
}
