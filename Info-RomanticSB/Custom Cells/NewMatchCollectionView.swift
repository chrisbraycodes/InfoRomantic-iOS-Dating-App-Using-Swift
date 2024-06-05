//
//  NewMatchCollectionView.swift
//  Info-RomanticSB
//
//  Created by Christopher Bray on 12/3/22.
//

import UIKit

class NewMatchCollectionViewCell: UICollectionViewCell {
    
    //MARK: - IBOutlets
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    
    override func awakeFromNib() {
        
        hideActivityIndicator()
    }
    
    
    func setupCell(avatarLink: String) {
        
        showActivityIndicator()
        
        self.avatarImageView.image = UIImage(named: "avatar")
        
        FileStorage.downloadImage(imageUrl: avatarLink) { (avatarImage) in
            self.hideActivityIndicator()
            self.avatarImageView.image = avatarImage?.circleMasked
        }
    }
    
    
    private func showActivityIndicator() {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
    }
    
    private func hideActivityIndicator() {
        activityIndicator.isHidden = true
        activityIndicator.stopAnimating()
    }

    
    
}
