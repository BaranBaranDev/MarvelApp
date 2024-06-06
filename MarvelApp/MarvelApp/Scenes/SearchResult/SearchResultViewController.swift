import UIKit
import SDWebImage

// MARK: - SearchDisplayLogic Protocol
protocol SearchDisplayLogic: AnyObject {
    func display(viewModel: SearchResultModels.search.Viewmodel)
}

final class SearchResultController: UIViewController {
    
    // MARK: - Properties
    private var marvelResults: [Results] = []
    private var searchQuery: String?
    
    // MARK: - Dependencies
    private var interactor: (SearchResultBusinessLogic & SearchResultDataStore)
    private let router: SearchResultRouting
    
    // MARK: - UI Elements
    private lazy var collectionView: UICollectionView = {
        var layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.showsVerticalScrollIndicator = false
        return cv
    }()
    
    // MARK: - Initialization
    init(interactor: (SearchResultBusinessLogic & SearchResultDataStore), router: SearchResultRouting) {
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
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        SDImageCache.shared.clearMemory()
        
        if (self.isViewLoaded) &&  (self.view.window == nil) {
            self.view = nil
        }
    }
    
    // MARK: - Layout
    private func setup() {
        view.backgroundColor = .secondarySystemFill
        view.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(SearchResultCollectionCell.self, forCellWithReuseIdentifier: SearchResultCollectionCell.reuseID)
    }
    
    private func layout() {
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(view.snp.topMargin)
            make.leading.equalTo(view.snp.leadingMargin)
            make.trailing.equalTo(view.snp.trailingMargin)
            make.bottom.equalTo(view.snp.bottomMargin)
        }
    }
    
    // MARK: - Helpers
    public func updateSearchText(_ searchText: String?) {
        guard let searchText = searchText else { return }
        self.searchQuery = searchText
        performSearch()
    }
    
    private func performSearch() {
        guard let searchQuery = searchQuery else { return }
        interactor.searchCharacter(request: SearchResultModels.search.Request(searchText: searchQuery))
    }
}

// MARK: - SearchDisplayLogic
extension SearchResultController: SearchDisplayLogic {
    func display(viewModel: SearchResultModels.search.Viewmodel) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.marvelResults = viewModel.characterList
            self.collectionView.reloadData()
        }
    }
}

// MARK: - UICollectionViewDelegate & UICollectionViewDataSource
extension SearchResultController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
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
        
        // Data
        interactor.selectedCharecter = marvelResults[indexPath.item]
        
        //Router
        router.routeDetail()
  
    }
}


