//
//  FavoritesViewController.swift
//  MarvelApp
//
//  Created by Baran Baran on 3.06.2024.


import UIKit
import SnapKit
import SDWebImage

// MARK: - FavoritesDisplayLogic Protocol
protocol FavoritesDisplayLogic: AnyObject {
    func displayFetchDatabase(viewModel: FavoritesModels.FetchDatabase.Viewmodel)
    func displayDeleteDatabase(viewModel: FavoritesModels.DeleteDatabase.Viewmodel)
    
}

final class FavoriteViewController: UIViewController {
    
    // MARK: - Properties
    
    private var favoriItems: [FavoriteCharacter] = []
    
    //MARK: Dependencies
    
    private var interactor: FavoritesBusinessLogic & FavoritesDataStore
    private let router: FavoritesRouting
    
    
    
    // MARK: - UI  Elements
    private lazy var tableView: UITableView = {
        let tv = UITableView()
        return tv
    }()
    
    
    // MARK: - İnitialization
    
    init(interactor: FavoritesBusinessLogic & FavoritesDataStore, router: FavoritesRouting) {
        self.interactor = interactor
        self.router = router
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        layout()
        fetchFavorites()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Bildirimi dinleme
        NotificationCenter.default.addObserver(forName: Notification.Name("Favorites"), object: nil, queue: nil) {[weak self] notification in
            guard let self = self else { return }
            self.fetchFavorites()
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        SDImageCache.shared.clearMemory()
        if (self.isViewLoaded) && (self.view.window == nil ) {
            self.view = nil
        }
    }
    
    
    // MARK: - Setup
    private func setup(){
        // Subview
        view.backgroundColor = .systemBackground
        view.addSubview(tableView)
        
        
        // Tableview Configure
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(FavoritesCell.self, forCellReuseIdentifier: FavoritesCell.reuseID)
        
        
        
        
    }
    
    // MARK: Layout
    private func layout(){
        tableView.snp.makeConstraints { make in
            make.top.equalTo(view.snp.topMargin)
            make.leading.equalTo(view.snp.leadingMargin)
            make.trailing.equalTo(view.snp.trailingMargin)
            make.bottom.equalTo(view.snp.bottomMargin)
        }
    }
    
    
    // MARK: - Helpers
    
    // interactora istek atalım
    private func fetchFavorites() {
        interactor.fetchDatabase(request: FavoritesModels.FetchDatabase.Request())
    }
    
    
}

// MARK: - FavoritesDisplayLogic

extension FavoriteViewController: FavoritesDisplayLogic {
    // fetch
    func displayFetchDatabase(viewModel: FavoritesModels.FetchDatabase.Viewmodel) {
        favoriItems = viewModel.fetchItems
        tableView.reloadData()
     
    }
    
    // delete
    func displayDeleteDatabase(viewModel: FavoritesModels.DeleteDatabase.Viewmodel) {
        if viewModel.success {
            fetchFavorites()
        } else {
            let alert = UIAlertController(title: "Error", message: "Failed to delete the character. Please try again.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
        }
    }
}

// MARK: -  UITableViewDelegate & UITableViewDataSource
extension FavoriteViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favoriItems.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: FavoritesCell.reuseID, for: indexPath) as? FavoritesCell else { return UITableViewCell()}
        let item = favoriItems[indexPath.item]
        cell.configure(with: item)
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UIScreen.main.bounds.height / 5
    }
    
    // route Detay page
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        // Aktarılacak veriyi dolduralım
         let item = favoriItems[indexPath.item]
         
        let selectedResult = Results(id: nil , name: item.name, description: item.characterDescription, modified: nil, thumbnail: nil, resourceURI: item.thumbnailUrl, comics: nil, series: nil, stories: nil, events: nil, urls: nil) // Fill with matching properties

        interactor.selectedCharecter = selectedResult
        // Geçiş
        router.routeDetail()
    }
    
    
    
    //  belirli bir satır için (indexPath ile belirtilen) sağa kaydırma eylemlerinin yapılandırmasını döner.
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { [weak self] (action, view, completionHandler) in
            guard let self = self else { return }
            let characterToDelete = self.favoriItems[indexPath.item]
            self.interactor.deleteDatabase(request: FavoritesModels.DeleteDatabase.Request(item: characterToDelete))
            completionHandler(true)
        }
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
    
}

