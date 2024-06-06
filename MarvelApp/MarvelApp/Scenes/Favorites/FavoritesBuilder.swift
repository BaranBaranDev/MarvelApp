//
//  FavoritesBuilder.swift
//  MarvelApp
//
//  Created by Baran Baran on 3.06.2024.
//

import Foundation

enum FavoritesBuilder {
    static func build() -> FavoriteViewController {
      
        let worker = FavoritesWorker()
        let presenter = FavoritesPresenter()
        let interactor = FavoritesInteractor(worker: worker, presenter: presenter)
        let router = FavoritesRouter()
        let vc = FavoriteViewController(interactor: interactor, router: router)
        
        presenter.viewController = vc
        router.dataStore = interactor
        router.controller = vc
        
        return vc
    }
}
