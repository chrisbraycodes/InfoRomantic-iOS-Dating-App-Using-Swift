//
//  UserCardFooterView.swift
//  Info-RomanticSB
//
//  Created by Christopher Bray on 12/2/22.
//

import UIKit

class UserCardFooterView: UIView {
    
    private var label = UILabel()
    private var gradientLayer: CAGradientLayer?
    
    init(withTitle title: String?, subTitle: String?) {
        super.init(frame: .zero)
        backgroundColor = .clear
        layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        layer.cornerRadius = 10
        clipsToBounds = true
        isOpaque = false
        initialize(title: title, subtitle: subTitle)
    }
    
    required init?(coder: NSCoder) {
        return nil
    }
    
    private func initialize(title: String?, subtitle: String?) {
        let attributedText = NSMutableAttributedString(string: (title ?? "") + "\n",
            attributes: NSAttributedString.Key.titleAttributes)
        
        if let subtitle = subtitle, subtitle != "" {
            attributedText.append(NSMutableAttributedString(string: subtitle, attributes: NSAttributedString.Key.subtitleAttributes))
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineSpacing = 4
            paragraphStyle.lineBreakMode = .byTruncatingTail
            attributedText.addAttributes([NSAttributedString.Key.paragraphStyle:
                paragraphStyle], range: NSRange(location: 0, length:
                attributedText.length))
            label.attributedText = attributedText
            addSubview(label)
        }
        
        label.attributedText = attributedText
        addSubview(label)
    }
    
    override func layoutSubviews() {
        let padding: CGFloat = 20
        
        label.frame = CGRect(x: padding, y: bounds.height - label.intrinsicContentSize.height - padding, width: bounds.width, height: label.intrinsicContentSize.height)
    }
    
}
