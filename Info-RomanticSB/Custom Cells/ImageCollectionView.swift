//
//  ImageCollectionView.swift
//  Info-RomanticSB
//
//  Created by Christopher Bray on 12/3/22.
//

import UIKit

class ImageCollectionViewCell: UICollectionViewCell {
    
    //MARK: - IBOutlets
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameAgeLabel: UILabel!
    @IBOutlet weak var countryCityLabel: UILabel!
    @IBOutlet weak var backgroundPlaceholder: UIView!
    
    let gradientLayer = CAGradientLayer()
    var indexPath: IndexPath!
    
    override func awakeFromNib() {
        imageView.layer.cornerRadius = 5
        imageView.clipsToBounds = true
    }
    
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)

        if indexPath.row == 0 {
            backgroundPlaceholder.isHidden = false
            setGradientBackground()
        } else {
            backgroundPlaceholder.isHidden = true
        }
    }
    
    func setupCell(image: UIImage, country: String, nameAge: String, indexPath: IndexPath) {
        
        self.indexPath = indexPath
        
        imageView.image = image
        
        countryCityLabel.text = indexPath.row == 0 ? country : ""
        nameAgeLabel.text = indexPath.row == 0 ? nameAge : ""
    }
    
    
    func setGradientBackground() {
        
        gradientLayer.removeFromSuperlayer()
        
        let colorTop = UIColor.clear.cgColor
        let colorBottom = UIColor.black.cgColor
        
        gradientLayer.colors = [colorTop, colorBottom]
        gradientLayer.locations = [0.0, 1.0]
        
        gradientLayer.cornerRadius = 5
        gradientLayer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        gradientLayer.frame = self.backgroundPlaceholder.bounds

        self.backgroundPlaceholder.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    
}
