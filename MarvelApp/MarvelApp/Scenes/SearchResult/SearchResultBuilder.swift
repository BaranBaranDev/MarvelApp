//
//  SearchResultBuilder.swift
//  MarvelApp
//
//  Created by Baran Baran on 31.05.2024.
//

import Foundation




import UIKit

final class SearchResultBuilder {
    static func build() -> SearchResultController {
        let worker = SearchResultWorker()
        let presenter = SearchResultPresenter()
        let interactor = SearchResultInteractor(worker: worker, presenter: presenter)
        let router = SearchResultRouter()
        let vc = SearchResultController(interactor: interactor, router: router)
        
        
        presenter.controller = vc
        router.dataStore = interactor
        router.controller = vc
        
        return vc
        
        
    }
}
