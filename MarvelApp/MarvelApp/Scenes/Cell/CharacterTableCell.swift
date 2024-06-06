//
//  CharacterTableCell.swift
//  MarvelApp
//
//  Created by Baran Baran on 31.05.2024.
//

import UIKit
import SnapKit
import SDWebImage

final class CharacterTableCell: UITableViewCell{
    
    // MARK:  Properties
    static let reuseID: String = "CharacterTableCell"
    
    
    // MARK: -  UI Elements
    private lazy var photoImage : UIImageView = {
        let iv = UIImageView()
        iv.clipsToBounds = true
        iv.contentMode = .scaleAspectFill
        iv.layer.cornerRadius = 8
        return iv
    }()
    
    private lazy var nameLabel: UILabel = {
        let lbl = UILabel()
        lbl.textColor = .label
        lbl.font = UIFont.boldSystemFont(ofSize: 18)
        lbl.font = UIFont.preferredFont(forTextStyle: .headline)
        lbl.adjustsFontForContentSizeCategory = true
        lbl.numberOfLines = 2
        lbl.lineBreakMode = .byWordWrapping
        return lbl
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let lbl = UILabel()
        lbl.textColor = .label
        lbl.font = UIFont.preferredFont(forTextStyle: .subheadline)
        lbl.adjustsFontForContentSizeCategory = true
        lbl.numberOfLines = 3
        lbl.lineBreakMode = .byWordWrapping
        return lbl
    }()
    
    
    private lazy var idLabel: UILabel = {
        let lbl = UILabel()
        lbl.textColor = .secondaryLabel
        lbl.font = UIFont.preferredFont(forTextStyle: .footnote)
        lbl.adjustsFontForContentSizeCategory = true
        return lbl
    }()
    
    
    private lazy var vStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [nameLabel,descriptionLabel,idLabel])
        stackView.axis = .vertical
        stackView.spacing = 4
        stackView.distribution = .fillProportionally
        return stackView
    }()
    
    
    // MARK: - İnitialization
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    override func prepareForReuse() {
        super.prepareForReuse()
        photoImage.image = nil
        nameLabel.text = nil
        descriptionLabel.text = nil
        idLabel.text = nil
    }

    
    // MARK: - Helpers
    
    private func setupUI(){
        drawDesing()
        layout()
    }

    public func configure(with model: Results) {
        setupImage(with: model.thumbnail)
        nameLabel.text = model.name
        idLabel.text = "ID: \(model.id ?? 0)"
        
        // Boş değilse ata
        if let description = model.description, !description.isEmpty {
                descriptionLabel.text = description
            } else { // boşsa varsayılan değerimiz olsun
                descriptionLabel.text = Constants.descriptionConst
            }
    }
}


extension CharacterTableCell {
    private func setupImage(with thumbnail: Thumbnail?) {
        // indicator başlat
        photoImage.sd_imageIndicator = SDWebImageActivityIndicator.gray
        // görsel url ayarla
        guard let thumbnail = thumbnail,
              let path = thumbnail.path,
              let extensionType = thumbnail.thumbnailExtension,
              let url = URL(string: "\(path).\(extensionType.rawValue)") else {
            photoImage.sd_setImage(with: nil, placeholderImage: UIImage(named: "emptyImagePlaceholder"))
            return
        }
        
        // görseli belirli boyutlandırma formatına göre ayarladım
        photoImage.sd_setImage(with: url, placeholderImage: nil, options: [.scaleDownLargeImages, .avoidAutoSetImage]) { [weak self] (image, error, cacheType, url) in
            guard let self = self else { return }
            if let image = image {
                let resizedImage = image.sd_resizedImage(with: CGSize(width: 80, height: 80), scaleMode: .aspectFill)
                // indicator dursun
                self.photoImage.sd_imageIndicator?.stopAnimatingIndicator()
                // görsel atandı
                self.photoImage.image = resizedImage
            }
        }
    }
}


// MARK: - Layout & DrawDesing
fileprivate extension CharacterTableCell{

    
    func drawDesing(){
        contentView.backgroundColor = .systemBackground
        contentView.addSubview(photoImage)
        contentView.addSubview(vStackView)
    }
    
    func layout(){
        photoImage.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(contentView.snp.leadingMargin)
            make.height.equalTo(80)
            make.width.equalTo(80)
        }
        
        vStackView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(photoImage.snp.trailing).offset(12)
            make.trailing.equalTo(contentView.snp.trailingMargin)
            
        }
    }
}
