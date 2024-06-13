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
    private var isGridView : Bool = false
    private var isLoadingMoreData: Bool = false
    
    
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
    
    
    private lazy var collectionView: UICollectionView = {
        var layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.showsVerticalScrollIndicator = false
        return cv
    }()
    
    private lazy var segmentedControl: UISegmentedControl = {
        let sc = UISegmentedControl(items: ["ASC", "DESC"])
        sc.addTarget(self, action: #selector(sortChanged(_:)), for: .valueChanged)
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
        view.addSubview(collectionView)
        
        
        
        // Tableview Configure
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(CharacterTableCell.self, forCellReuseIdentifier: CharacterTableCell.reuseID)
        
        
        // SearchController
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.searchBar.delegate = self
        searchController.searchResultsUpdater = self  // arama sonuçlarını güncellemek için delege belirttik. UISearchResultsUpdating Protokolü engtegre edeceğim
        
        
        // CollectionView Configure
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(SearchResultCollectionCell.self, forCellWithReuseIdentifier: SearchResultCollectionCell.reuseID)
        
        
        
        
        // ToggleView
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "list.bullet.below.rectangle"),
            style: .plain,
            target: self,
            action: #selector(toggleView)
        )
        
        collectionView.isHidden = true
        
        // Segmented Control
        navigationItem.titleView = segmentedControl
        segmentedControl.selectedSegmentIndex = 0
        
        
        // UIRefrestController
        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        collectionView.refreshControl = UIRefreshControl()
        collectionView.refreshControl?.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        
        
    }
    
    // MARK: Layout
    private func layout(){
        tableView.snp.makeConstraints { make in
            make.top.equalTo(view.snp.topMargin)
            make.leading.equalTo(view.snp.leadingMargin)
            make.trailing.equalTo(view.snp.trailingMargin)
            make.bottom.equalTo(view.snp.bottomMargin)
        }
        
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(view.snp.topMargin)
            make.leading.equalTo(view.snp.leadingMargin)
            make.trailing.equalTo(view.snp.trailingMargin)
            make.bottom.equalTo(view.snp.bottomMargin)
        }
    }
    
    // MARK: - Actions
    
    @objc fileprivate func toggleView(){
        isGridView.toggle()
        if isGridView {
            tableView.isHidden = true
            collectionView.isHidden = false
            navigationItem.rightBarButtonItem?.image = UIImage(systemName: "list.bullet.below.rectangle")
        } else {
            tableView.isHidden = false
            collectionView.isHidden = true
            navigationItem.rightBarButtonItem?.image = UIImage(systemName: "square.grid.2x2")
        }
    }
    
    @objc fileprivate func sortChanged(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 { //asc
            marvelResults.sort { $0.name! < $1.name! } // A-Z
        } else { //desc
            marvelResults.sort { $0.name! > $1.name! } // Z-A
        }
        tableView.reloadData()
        collectionView.reloadData()
    }
    
    
    @objc fileprivate func refreshData() {
        interactor.fetchCharecter(request: CharacterModels.fetchCharacter.Request()) // Verileri yenilemek için API çağrısı
    }
    
    
}

// MARK: - CharacterDisplayLogic
extension CharacterViewController: CharacterDisplayLogic {
    func display(viewModel: CharacterModels.fetchCharacter.Viewmodel) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            if self.isLoadingMoreData {
                self.marvelResults.append(contentsOf: viewModel.characterList) // Yeni verileri mevcut listenin sonuna ekler
                self.isLoadingMoreData = false // Daha fazla veri yükleme işlemi tamamlandı
            } else {
                self.marvelResults = viewModel.characterList // Yeni verilerle listeyi tamamen günceller
            }
            
            // segmentedControl
            if segmentedControl.selectedSegmentIndex == 0 { //asc
                marvelResults.sort { $0.name! < $1.name! } // A-Z
            } else { //desc
                marvelResults.sort { $0.name! > $1.name! } // Z-A
            }
            self.tableView.reloadData() // Tabloyu yeniden yükle
            self.collectionView.reloadData() // Koleksiyonu yeniden yükle
            self.tableView.refreshControl?.endRefreshing() // Yenileme işlemini durdur
            self.collectionView.refreshControl?.endRefreshing() // Yenileme işlemini durdur
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




// MARK: - UICollectionViewDelegate & UICollectionViewDataSource
extension CharacterViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return marvelResults.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchResultCollectionCell.reuseID, for: indexPath) as? SearchResultCollectionCell else {
            return UICollectionViewCell()
        }
        let model = marvelResults[indexPath.item]
        cell.configure(with: model)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: 160, height: 180)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        // Aktarılacak veriyi dolduralım
        interactor.selectedCharecter = marvelResults[indexPath.item]
        
        // Geçiş
        router.routeDetail()
    }
}

// MARK: - UIScrollViewDelegate
extension CharacterViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // Kaydırma pozisyonunu alır
        let position = scrollView.contentOffset.y
        
        // İçeriğin toplam yüksekliğini alır
        let contentHeight = scrollView.contentSize.height
        
        // ScrollView'ın görünür alanının yüksekliğini alır
        let scrollViewHeight = scrollView.frame.size.height
        
        // Kullanıcı içeriğin sonuna yaklaştı mı kontrol eder
        if position > (contentHeight - scrollViewHeight - 100) {
            // Eğer halihazırda veri çekme işlemi yapılıyorsa, fonksiyondan çıkar
            guard !isLoadingMoreData else { return }
            
            // Veri çekme işlemi başlatıldığını işaretle
            isLoadingMoreData = true
            
            // Daha fazla veri çek
            loadMoreData()
        }
    }
    
    private func loadMoreData(){
        interactor.fetchCharecter(request: CharacterModels.fetchCharacter.Request())
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
