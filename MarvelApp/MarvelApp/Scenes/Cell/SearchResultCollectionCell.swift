//
//  SearchResultCollectionCell.swift
//  MarvelApp
//
//  Created by Baran Baran on 31.05.2024.
//

import UIKit
import SDWebImage

final class SearchResultCollectionCell: UICollectionViewCell {
    
    // MARK: - Properties
    static let reuseID = "SearchResultCollectionCell"
    
    
    // MARK: - UI Elements
    private lazy var photoImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 8
        return imageView
    }()
    
    private lazy var nameLabel: UILabel = {
        let lbl = UILabel()
        lbl.textColor = .label
        lbl.numberOfLines = 1
        lbl.lineBreakMode = .byWordWrapping
        lbl.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        return lbl
    }()
    
    
    // MARK: - İnitialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
        layout()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    
    override func prepareForReuse() {
        photoImage.image = nil
        nameLabel.text = nil
    }
    
    
    // MARK: - Setup
    
    private func setup(){
        contentView.backgroundColor = .systemBackground
        contentView.addSubview(photoImage)
        contentView.addSubview(nameLabel)
        
        
    }
    
    
    
    // MARK: - Helpers
    
    public func configure(with model: Results) {
        setupImage(with: model.thumbnail)
        nameLabel.text = model.name ?? Constants.descriptionConst
    }
    
    private func setupImage(with thumbnail: Thumbnail?) {
        
        photoImage.sd_imageIndicator = SDWebImageActivityIndicator.gray
        
        guard let thumbnail = thumbnail,
              let path = thumbnail.path,
              let extensionType = thumbnail.thumbnailExtension,
              let url = URL(string: "\(path).\(extensionType.rawValue)") else {
            photoImage.sd_setImage(with: nil, placeholderImage: UIImage(named: "emptyImagePlaceholder"))
            return
        }
        
        
        photoImage.sd_setImage(with: url, placeholderImage: nil, options: [.scaleDownLargeImages, .avoidAutoSetImage]) { [weak self] (image, error, cacheType, url) in
            guard let self = self else { return }
            if let image = image {
                let resizedImage = image.sd_resizedImage(with: CGSize(width: 80, height: 80), scaleMode: .aspectFill)
                self.photoImage.sd_imageIndicator?.stopAnimatingIndicator()
                self.photoImage.image = resizedImage
            }
        }
    }
}


private extension SearchResultCollectionCell {
    func layout(){
        photoImage.snp.makeConstraints { make in
            make.top.equalTo(contentView.snp.topMargin)
            make.leading.equalTo(contentView.snp.leadingMargin)
            make.trailing.equalTo(contentView.snp.trailingMargin)
            make.height.equalTo(150)
            
        }
        
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(photoImage.snp.bottom).offset(4)
            make.bottom.equalTo(contentView.snp.bottom).inset(4)
            make.leading.equalTo(photoImage.snp.leading)
            make.trailing.equalTo(photoImage.snp.trailing)
        }
        
    }
}
