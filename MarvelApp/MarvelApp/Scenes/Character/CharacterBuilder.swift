//
//  CharacterBuilder.swift
//  MarvelApp
//
//  Created by Baran Baran on 6.06.2024.
//

import Foundation


enum CharacterBuilder {
    static func build() -> CharacterViewController {
        let worker = CharacterWorker()
        let presenter = CharacterPresenter()
        let interactor = CharacterInteractor(worker: worker, presenter: presenter)
        let router = CharacterRouter()
        let vc = CharacterViewController(interactor: interactor, router: router)
        
        
        presenter.controller = vc
        router.dataStore = interactor
        router.controller = vc
        
        return vc
    }
}

