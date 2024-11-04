//
//  TextFormatter.swift
//  Pods
//
//  Created by Anurag Tyagi on 22/10/24.
//

import UIKit

extension NSMutableAttributedString {
    /// Applies bold formatting to text between ** markers
    func applyBoldFormat(boldFont: UIFont = UIFont.boldSystemFont(ofSize: UIFont.systemFontSize), normalFont: UIFont = UIFont.systemFont(ofSize: UIFont.systemFontSize)) {
        let fullText = self.string as NSString
        
        // Regular expression to find **text** patterns
        let regex = try! NSRegularExpression(pattern: "\\*\\*(.*?)\\*\\*")
        
        // Get matches for the pattern
        let matches = regex.matches(in: self.string, range: NSRange(location: 0, length: fullText.length))
        
        // Work backwards to replace the ** and apply bold, so ranges don't shift
        for match in matches.reversed() {
            // Get the range for the **text** including the **
            let fullRange = match.range(at: 0)
            // Get the range for the actual text between the ** (group 1 in regex)
            let boldTextRange = match.range(at: 1)
            
            // Extract the bold text
            let boldText = fullText.substring(with: boldTextRange)
            
            // Replace the full match (**text**) with the bold text only
            self.replaceCharacters(in: fullRange, with: boldText)
            
            // Apply bold formatting to the boldText only
            let newRange = NSRange(location: fullRange.location, length: boldText.count)
            self.addAttributes([.font: boldFont], range: newRange)
        }
    }
}
