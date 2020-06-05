//
//  PlaceHolderTextView.swift
//  JTAppleCalendar
//
//  Created by 吉川椛 on 2020/05/14.
//  Copyright © 2020 com.litech. All rights reserved.
//

import UIKit

@IBDesignable class PlaceHolderTextView: UITextView {
    
    // プレースホルダーに表示する文字列（ローカライズ付き）
    @IBInspectable var localizedString: String = "" {
        didSet {
            guard !localizedString.isEmpty else { return }
            // Localizable.stringsを参照する
            placeholderLabel.text = NSLocalizedString(localizedString, comment: "")
            placeholderLabel.sizeToFit()
            placeholderLabel.font = placeholderLabel.font.withSize(14)
        }
    }

    // プレースホルダー用ラベルを作成
    private lazy var placeholderLabel = UILabel(frame: CGRect(x: 6, y: 6, width: 0, height: 0))

    override func awakeFromNib() {
        super.awakeFromNib()
        delegate = self
        configurePlaceholder()
        togglePlaceholder()
    }

    // プレースホルダーを設定する
    private func configurePlaceholder() {
        placeholderLabel.textColor = UIColor(red: 196/255, green: 196/255, blue: 198/255, alpha: 1.0)
        addSubview(placeholderLabel)
    }

    // プレースホルダーの表示・非表示切り替え
    private func togglePlaceholder() {
        // テキスト未入力の場合のみプレースホルダーを表示する
        placeholderLabel.isHidden = text.isEmpty ? false : true
    }

}

// MARK: -  UITextView Delegate
extension PlaceHolderTextView: UITextViewDelegate {
    // テキストが書き換えられるたびに呼ばれる
    func textViewDidChange(_ textView: UITextView) {
        togglePlaceholder()
    }
}
