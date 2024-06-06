//
//  SearchResultRouter.swift
//  MarvelApp
//
//  Created by Baran Baran on 31.05.2024.




protocol SearchResultRouting {
    func routeDetail()
}

protocol SearchResultDataPassing {
    var dataStore: SearchResultDataStore? { get }
}



final class SearchResultRouter: SearchResultDataPassing {
    
    var dataStore: SearchResultDataStore?
    weak var controller: SearchResultController?
    
}

extension SearchResultRouter: SearchResultRouting {
    func routeDetail() {
        guard let results = dataStore?.selectedCharecter else { return }
        
        let vc = DetailBuilder.build(with: results, isFromFavorites: false)
        controller?.presentingViewController?.navigationController?.pushViewController(vc, animated:true)

       
        
    }
}
