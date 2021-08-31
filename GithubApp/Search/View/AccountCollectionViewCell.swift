//
//  AccountCollectionViewCell.swift
//  GithubApp
//
//  Created by Masato Takamura on 2021/08/29.
//

import UIKit

final class AccountCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet private weak var iconImageView: UIImageView!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        iconImageView.image = nil
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        clipsToBounds = true
        layer.cornerRadius = frame.width / 2
        layer.borderWidth = 1
        layer.borderColor = UIColor.green.cgColor
    }
    
    func configure(item: Item) {
        iconImageView.image = UIImage(url: item.owner.avatar)
    }

}
