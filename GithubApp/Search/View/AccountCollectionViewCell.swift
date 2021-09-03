//
//  AccountCollectionViewCell.swift
//  GithubApp
//
//  Created by Masato Takamura on 2021/08/29.
//

import UIKit
import PINRemoteImage

final class AccountCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet private weak var iconImageView: UIImageView! {
        didSet {
            iconImageView.pin_updateWithProgress = true
        }
    }
    
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
        guard let imageUrl = URL(string: item.owner.avatar) else { return }
        PINRemoteImageManager.shared().cache.removeObject(forKey: PINRemoteImageManager.shared().cacheKey(for: imageUrl, processorKey: nil))
        iconImageView.pin_setImage(from: imageUrl, placeholderImage: UIImage(named: "DefImage"))
    }

}
