//
//  CharacterViewController.swift
//  MarvelApp
//
//  Created by Baran Baran on 6.06.2024.

import UIKit
import SnapKit
import SDWebImage

// MARK:  CharacterDisplayLogic Protocol
protocol CharacterDisplayLogic: AnyObject {
    func display(viewModel: CharacterModels.fetchCharacter.Viewmodel)
}


final class CharacterViewController: UIViewController {
    
    // MARK:  Properties
    private var marvelResults : [Results] = []
    
    
    //MARK: Dependencies
    private var interactor: (CharacterDataStore & CharacterBusinessLogic)
    private let router: CharacterRouting
    

    // MARK: - İnitialization
    
    init(interactor: CharacterDataStore & CharacterBusinessLogic, router: CharacterRouting) {
        self.interactor = interactor
        self.router = router
        super.init(nibName: nil, bundle: nil)
        interactor.fetchCharecter(request: CharacterModels.fetchCharacter.Request())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - UI  Elements
    private lazy var tableView: UITableView = {
        let tv = UITableView()
        return tv
    }()
    
    private lazy var searchController : UISearchController = {
        let sc = UISearchController(searchResultsController: SearchResultBuilder.build())
        sc.searchBar.placeholder = "Search Character"
        sc.searchBar.searchBarStyle = .prominent
        return sc
    }()
    
    

    
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        layout()
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Bellek uyarısı alındığında yapılacak işlemler
        SDImageCache.shared.clearMemory()
        
        // Kullanılmayan view'ları bellekten kaldırma
        if (self.isViewLoaded) && (self.view.window == nil) {
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
        tableView.register(CharacterTableCell.self, forCellReuseIdentifier: CharacterTableCell.reuseID)
        
        
        // SearchController
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.searchBar.delegate = self
        searchController.searchResultsUpdater = self  // arama sonuçlarını güncellemek için delege belirttik. UISearchResultsUpdating Protokolü engtegre edeceğim
        
        
        
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
}


// MARK: - CharacterDisplayLogic
extension CharacterViewController: CharacterDisplayLogic {
    func display(viewModel: CharacterModels.fetchCharacter.Viewmodel) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.marvelResults = viewModel.characterList
            tableView.reloadData()
        }
    }
}


// MARK: -  UITableViewDelegate & UITableViewDataSource
extension CharacterViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return marvelResults.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CharacterTableCell.reuseID, for: indexPath) as? CharacterTableCell else { return UITableViewCell() }
        let resultModel = marvelResults[indexPath.item]
        cell.configure(with: resultModel)
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UIScreen.main.bounds.height / 5
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        // Aktarılacak veriyi dolduralım
        interactor.selectedCharecter = marvelResults[indexPath.item]
        
        // Geçiş
        router.routeDetail()
    }
    
}




// MARK: - UISearchResultsUpdating Protocol

extension CharacterViewController: UISearchResultsUpdating, UISearchBarDelegate {

    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text?.trimmingCharacters(in: .whitespaces), !searchText.isEmpty else { return }
        
        if let vc = searchController.searchResultsController as? SearchResultController {
            vc.updateSearchText(searchText)
        }
       
    }
}
