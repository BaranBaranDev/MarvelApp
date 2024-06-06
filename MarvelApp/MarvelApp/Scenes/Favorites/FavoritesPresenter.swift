//
//  FavoritesPresenter.swift
//  MarvelApp
//
//  Created by Baran Baran on 3.06.2024.
//

import UIKit

protocol FavoritesPresentationLogic {
    func presentFetchData(response: FavoritesModels.FetchDatabase.Response)
    func presentDeleteDatabase(response: FavoritesModels.DeleteDatabase.Response)
}

final class FavoritesPresenter: FavoritesPresentationLogic {
    weak var viewController: FavoritesDisplayLogic?

    func presentFetchData(response: FavoritesModels.FetchDatabase.Response) {
        let viewModel = FavoritesModels.FetchDatabase.Viewmodel(fetchItems: response.fetchItems)
        viewController?.displayFetchDatabase(viewModel: viewModel)
    }

    func presentDeleteDatabase(response: FavoritesModels.DeleteDatabase.Response) {
        let viewModel = FavoritesModels.DeleteDatabase.Viewmodel(success: response.success)
        viewController?.displayDeleteDatabase(viewModel: viewModel)
    }
}
