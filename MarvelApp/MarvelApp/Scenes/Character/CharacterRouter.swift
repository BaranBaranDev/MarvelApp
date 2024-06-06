//
//  CharacterRouter.swift
//  MarvelApp
//
//  Created by Baran Baran on 6.06.2024.


import UIKit

protocol CharacterRouting {
    func routeDetail()
}

protocol CharacterDataPassing {
    var dataStore: CharacterDataStore? { get }
}

final class CharacterRouter: CharacterDataPassing {
    
    var dataStore: CharacterDataStore?
    
    
    weak var controller: CharacterViewController?
}

extension CharacterRouter: CharacterRouting {
    func routeDetail() {
        guard let results = dataStore?.selectedCharecter else { return }
        
        
        let vc = DetailBuilder.build(with: results, isFromFavorites: false)
        controller?.navigationController?.pushViewController(vc, animated: true)
        
    }
}
