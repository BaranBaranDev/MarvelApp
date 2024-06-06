//
//  FavoritesRouter.swift
//  MarvelApp
//
//  Created by Baran Baran on 3.06.2024.

import UIKit

protocol FavoritesRouting {
    func routeDetail()
}

protocol FavoritesrDataPassing {
    var dataStore: FavoritesDataStore? { get }
}

final class FavoritesRouter: FavoritesrDataPassing {
    
    var dataStore: FavoritesDataStore?
    
    
    weak var controller: FavoriteViewController?
}

extension FavoritesRouter: FavoritesRouting {
    func routeDetail() {
        guard let results = dataStore?.selectedCharecter else { return }
        
        
        let vc = DetailBuilder.build(with: results, isFromFavorites: true)
        controller?.navigationController?.pushViewController(vc, animated: true)
        
    }
}
