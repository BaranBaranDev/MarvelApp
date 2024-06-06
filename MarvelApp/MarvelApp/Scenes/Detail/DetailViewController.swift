//  DetailViewController.swift
//  MarvelApp
//
//  Created by Baran Baran on 1.06.2024.

import UIKit
import SnapKit
import SDWebImage

protocol DetailDisplayLogic: AnyObject {
    
}

final class DetailViewController: UIViewController {
    
    // MARK: - Properties
    private var selectedCharacter: Results?
    private var isFavorite = false
    private var isFromFavorites: Bool
    
    //MARK: Dependencies
    
    private var interactor: DetailBusinessLogic
    
    
    // MARK: - UI  Elements
    
    private lazy var photoImage: UIImageView = {
        let iv = UIImageView()
        iv.clipsToBounds = true
        iv.contentMode = .scaleAspectFill
        return iv
    }()
    
    private lazy var nameLabel: UILabel = {
        let lbl = UILabel()
        lbl.textColor = .label
        lbl.adjustsFontSizeToFitWidth = true
        return lbl
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let lbl = UILabel()
        lbl.textColor = .label
        lbl.font = UIFont.systemFont(ofSize: 19, weight: .bold)
        lbl.adjustsFontForContentSizeCategory = true
        lbl.numberOfLines = 7
        lbl.lineBreakMode = .byWordWrapping
        return lbl
    }()
    
    
    // MARK: - Initialization
    
    init(selectedCharacter: Results? = nil,interactor: DetailBusinessLogic, isFromFavorites: Bool) {
        self.selectedCharacter = selectedCharacter
        self.interactor = interactor
        self.isFromFavorites = isFromFavorites
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        layout()
        configure()
    }
    
    
    // Bellek
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        SDImageCache.shared.clearMemory()
        if (self.isViewLoaded) && (self.view.window == nil) {
            self.view = nil
        }
    }
    

    // MARK: - Setup
    private func setup(){
        // Subview
        view.backgroundColor = .systemBackground
        view.addSubview(photoImage)
        view.addSubview(descriptionLabel)
        
        // NavBar
        navbarConfigure()
    }
    
    // MARK:  NavBar Configure
    private func navbarConfigure(){
        // Eğer favoriler sayfasından gelirse true
        if isFromFavorites {
            navigationController?.navigationBar.prefersLargeTitles = true
            navigationItem.title = selectedCharacter?.name ?? ""
        } else {
            // Add favorite button
            // Charecter veya SearchResults dan gelenler için
            navigationController?.navigationBar.prefersLargeTitles = true
            navigationItem.title = selectedCharacter?.name ?? ""
            
            // Add favorite button
            navigationItem.rightBarButtonItem = UIBarButtonItem(
                image: UIImage(systemName: "star"),
                style: .plain,
                target: self,
                action: #selector(favoriteButtonTapped)
            )
        }
    }
    
    // MARK: - Layout
    private func layout(){
        photoImage.snp.makeConstraints { make in
            make.top.equalTo(view.snp.topMargin)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(300)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(photoImage.snp.bottom).offset(32)
            make.leading.equalTo(view.snp.leadingMargin)
            make.trailing.equalTo(view.snp.trailingMargin)
        }
        
        
        
    }
    
    // MARK: - Actions
    @objc fileprivate func favoriteButtonTapped() {
        
        isFavorite.toggle()
        
        let imageName = isFavorite ? "star.fill" : "star"
        navigationItem.rightBarButtonItem?.image = UIImage(systemName: imageName)
        
        // Save
        guard let selectedCharacter = selectedCharacter else { return }
        interactor.saveData(request: DetailModels.saveData.Request(selectedItem: selectedCharacter))
    }
}

// MARK: - Configure

private extension DetailViewController {
    func configure() {
        
        // Gelen açıklama boş mu ?
        if let description = selectedCharacter?.description, !description.isEmpty {
            descriptionLabel.text = description
        } else {
            descriptionLabel.text = Constants.descriptionConst
        }
        
        
        // Favori vc den mi geldi ?
        if isFromFavorites {
            guard let url = URL(string: selectedCharacter?.resourceURI ?? "") else { return }
            photoImage.sd_setImage(with: url)
        } else {
            setupImage(with: selectedCharacter?.thumbnail)
        }
        
        
    }
    
    func setupImage(with artworkUrl: Thumbnail?) {
        photoImage.sd_imageIndicator = SDWebImageActivityIndicator.gray
        guard let artworkUrl = artworkUrl,
              let path = artworkUrl.path,
              let extensionType = artworkUrl.thumbnailExtension,
              let url = URL(string: "\(path).\(extensionType.rawValue)") else {
            // Boş veya geçersiz bir URL ise, boş resmi göster ve loading indicator'ı durdur
            photoImage.sd_setImage(with: nil, placeholderImage: UIImage(named: "emptyImagePlaceholder"))
            return
        }
        // Doğru URL ile resmi yükle
        photoImage.sd_setImage(with: url, placeholderImage: nil, options: [], completed: { [weak self] _, _, _, _ in
            // Resim yüklenme tamamlandığında
            guard let self = self else { return }
            self.photoImage.sd_imageIndicator?.stopAnimatingIndicator()
        })
    }
}
