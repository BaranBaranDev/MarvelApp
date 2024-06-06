//
//  DetailWorker.swift
//  MarvelApp
//
//  Created by Baran Baran on 1.06.2024.


import UIKit

protocol DetailDataWorkerProtocol: AnyObject {
    func saveFavoriteCharacter(model: Results, completion: @escaping (Result<Void, Error>) -> Void)
    
}




final class DetailWorker: DetailDataWorkerProtocol {
    
    func saveFavoriteCharacter(model: Results, completion: @escaping (Result<Void, Error>) -> Void) {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else{return}
        let context = appDelegate.persistentContainer.viewContext
        
        let item = FavoriteCharacter(context: context)
        
        item.name = model.name
        item.characterDescription = model.description
        item.id = Int64(model.id ?? 0)
        
        if let thumbnail = model.thumbnail {
            let urlString = "\(thumbnail.path ?? "").\(thumbnail.thumbnailExtension?.rawValue ?? "")"
            item.thumbnailUrl = urlString
        }
        
        
        do{
            try context.save()
            completion(.success(()))
        }catch{
            completion(.failure(error))
        }
        
    }
}



