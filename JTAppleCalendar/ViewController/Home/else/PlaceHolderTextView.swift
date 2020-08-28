//
//  PlaceHolderTextView.swift
//  JTAppleCalendar
//
//  Created by 吉川椛 on 2020/05/14.
//  Copyright © 2020 com.litech. All rights reserved.
//

import UIKit

@IBDesignable class PlaceHolderTextView: UITextView {
    
    @IBInspectable var localizedString: String = "" {
        didSet {
            guard !localizedString.isEmpty else { return }
            placeholderLabel.text = NSLocalizedString(localizedString, comment: "")
            placeholderLabel.sizeToFit()
            placeholderLabel.font = placeholderLabel.font.withSize(14)
        }
    }
    
    private lazy var placeholderLabel = UILabel(frame: CGRect(x: 6, y: 6, width: 0, height: 0))

    override func awakeFromNib() {
        super.awakeFromNib()
        delegate = self
        configurePlaceholder()
        togglePlaceholder()
    }
    
    private func configurePlaceholder() {
        placeholderLabel.textColor = UIColor(red: 196/255, green: 196/255, blue: 198/255, alpha: 1.0)
        addSubview(placeholderLabel)
    }
    
    private func togglePlaceholder() {
        
        placeholderLabel.isHidden = text.isEmpty ? false : true
    }

}

// MARK: -  UITextView Delegate
extension PlaceHolderTextView: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        togglePlaceholder()
    }
}
