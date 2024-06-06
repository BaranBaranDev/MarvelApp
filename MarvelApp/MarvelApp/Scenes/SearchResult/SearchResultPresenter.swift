//
//  SearchResultPresenter.swift
//  MarvelApp
//
//  Created by Baran Baran on 31.05.2024.
//





protocol SearchPresentetionLogic {
    func presentFetchCharecter(response: SearchResultModels.search.Response)
}


final class SearchResultPresenter {
    weak var controller: SearchDisplayLogic?
}



extension SearchResultPresenter: SearchPresentetionLogic {
    func presentFetchCharecter(response: SearchResultModels.search.Response) {
        controller?.display(viewModel: SearchResultModels.search.Viewmodel(characterList: response.characterList))
    }
    
    
}
