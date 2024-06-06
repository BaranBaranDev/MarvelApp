//
//  MarvelModel.swift
//  MarvelApp
//
//  Created by Baran Baran on 30.05.2024.
//


import Foundation

// MARK: - MarvelResponse
struct MarvelResponse: Codable {
    let data: DataClass?
}

// MARK: - DataClass
struct DataClass: Codable {
    let offset, limit, total, count: Int?
    let results: [Results]?
}

// MARK: - Result
struct Results: Codable {
    let id: Int?
    let name, description: String?
    let modified: String? // Use String for date to handle custom formatting later
    let thumbnail: Thumbnail?
    let resourceURI: String?
    let comics, series: Comics?
    let stories: Stories?
    let events: Comics?
    let urls: [URLElement]?
}

// MARK: - Comics
struct Comics: Codable {
    let available: Int?
    let collectionURI: String?
    let items: [ComicsItem]?
    let returned: Int?
}

// MARK: - ComicsItem
struct ComicsItem: Codable {
    let resourceURI: String?
    let name: String?
}

// MARK: - Stories
struct Stories: Codable {
    let available: Int?
    let collectionURI: String?
    let items: [StoriesItem]?
    let returned: Int?
}

// MARK: - StoriesItem
struct StoriesItem: Codable {
    let resourceURI: String?
    let name: String?
    let type: ItemType?
}

enum ItemType: String, Codable {
    case cover
    case empty = ""
    case interiorStory
}

// MARK: - Thumbnail
struct Thumbnail: Codable {
    let path: String?
    let thumbnailExtension: Extension?
    
    enum CodingKeys: String, CodingKey {
        case path
        case thumbnailExtension = "extension" // Map "extension" to "thumbnailExtension"
    }
}

enum Extension: String, Codable {
    case gif
    case jpg
}

// MARK: - URLElement
struct URLElement: Codable {
    let type: URLType?
    let url: String?
}

enum URLType: String, Codable {
    case comiclink
    case detail
    case wiki
}
