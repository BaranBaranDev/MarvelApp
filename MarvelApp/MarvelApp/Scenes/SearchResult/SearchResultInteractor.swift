//
//  SearchResultInteractor.swift
//  MarvelApp
//
//  Created by Baran Baran on 31.05.2024.



import UIKit

protocol SearchResultBusinessLogic {
    func searchCharacter(request: SearchResultModels.search.Request)
}

protocol SearchResultDataStore {
    var selectedCharecter: Results? { get set }

}


final class SearchResultInteractor: SearchResultDataStore {
    
    //MARK: DataStore Logic
    var selectedCharecter: Results?
    
    //MARK: Dependencies
    private let worker: SearchResultNetworkWorker
    private let presenter: SearchPresentetionLogic
    
    init(selectedCharecter: Results? = nil, worker: SearchResultNetworkWorker, presenter: SearchPresentetionLogic) {
        self.worker = worker
        self.presenter = presenter
    }
    
    
}


extension SearchResultInteractor: SearchResultBusinessLogic {
    func searchCharacter(request: SearchResultModels.search.Request) {
        worker.searchCharecter(searchText: request.searchText) { [ weak self ] result in
            guard let self = self else { return }
            switch result {
            case .success(let marvelRes):
                guard let results = marvelRes.data?.results else { return }
                presenter.presentFetchCharecter(response: SearchResultModels.search.Response(characterList: results))
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    

    
    
}
