//
//  CharacterPresenter.swift
//  MarvelApp
//
//  Created by Baran Baran on 6.06.2024.
//


protocol CharacterPresentetionLogic {
    func presentFetchCharecter(response: CharacterModels.fetchCharacter.Response)
}




final class CharacterPresenter {
    weak var controller: CharacterDisplayLogic?
}



extension CharacterPresenter: CharacterPresentetionLogic {
    func presentFetchCharecter(response: CharacterModels.fetchCharacter.Response) {
        controller?.display(viewModel: CharacterModels.fetchCharacter.Viewmodel(characterList: response.characterList))
    }
    
    
}
