//
//  MarvelModels.swift
//  TesteiOS_Marvel
//
//  Created by Francisco Costa Neto on 20/08/19.
//  Copyright © 2019 Francisco Costa Neto. All rights reserved.
//

import Foundation



struct PersonaModel: Codable {
    let attributionHTML : String?
    let attributionText : String?
    let copyright : String?
    let data : PersonaModelData?
    
    enum CodingKeys: String, CodingKey {
        case attributionHTML = "attributionHTML"
        case attributionText = "attributionText"
        case copyright = "copyright"
        case data = "data"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        attributionHTML = try values.decodeIfPresent(String.self, forKey: .attributionHTML)
        attributionText = try values.decodeIfPresent(String.self, forKey: .attributionText)
        copyright = try values.decodeIfPresent(String.self, forKey: .copyright)
        data = try values.decodeIfPresent(PersonaModelData.self, forKey: .data)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(attributionHTML, forKey: .attributionHTML)
        try container.encode(attributionText, forKey: .attributionText)
        try container.encode(copyright, forKey: .copyright)
        try data?.encode(to: encoder)
    }
}

struct PersonaModelData: Codable {
    let count : Int?
    let limit : Int?
    let offset : Int?
    let results : [PersonaModelDataResult]?
    let total : Int?
    
    enum CodingKeys: String, CodingKey {
        case count = "count"
        case limit = "limit"
        case offset = "offset"
        case results = "results"
        case total = "total"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        count = try values.decodeIfPresent(Int.self, forKey: .count)
        limit = try values.decodeIfPresent(Int.self, forKey: .limit)
        offset = try values.decodeIfPresent(Int.self, forKey: .offset)
        results = try values.decodeIfPresent([PersonaModelDataResult].self, forKey: .results)
        total = try values.decodeIfPresent(Int.self, forKey: .total)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(count, forKey: .count)
        try container.encode(limit, forKey: .limit)
        try container.encode(offset, forKey: .offset)
        try container.encode(results, forKey: .results)
        try container.encode(total, forKey: .total)
    }
}

struct PersonaModelDataResult: Codable {
    let comics : Comics?
    let descriptionField : String?
    let id : Int?
    let modified : String?
    let name : String?
    let resourceURI : String?
    let thumbnail : PersonaDataImage?
    let urls : [PersonaDataUrls]?
    
    enum CodingKeys: String, CodingKey {
        case comics = "comics"
        case descriptionField = "description"
        case events = "events"
        case id = "id"
        case modified = "modified"
        case name = "name"
        case resourceURI = "resourceURI"
        case series = "series"
        case stories = "stories"
        case thumbnail = "thumbnail"
        case urls = "urls"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        comics = try values.decodeIfPresent(Comics.self, forKey: .comics)
        descriptionField = try values.decodeIfPresent(String.self, forKey: .descriptionField)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        modified = try values.decodeIfPresent(String.self, forKey: .modified)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        resourceURI = try values.decodeIfPresent(String.self, forKey: .resourceURI)
        thumbnail = try values.decodeIfPresent(PersonaDataImage.self, forKey: .thumbnail)
        urls = try values.decodeIfPresent([PersonaDataUrls].self, forKey: .urls)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try comics?.encode(to: encoder)
        try container.encode(descriptionField, forKey: .descriptionField)
        try container.encode(id, forKey: .id)
        try container.encode(modified, forKey: .modified)
        try container.encode(name, forKey: .name)
        try container.encode(resourceURI, forKey: .resourceURI)
        try thumbnail?.encode(to: encoder)
        try container.encode(urls, forKey: .urls)
    }
}


struct Comics: Codable {
    let available : Int?
    let collectionURI : String?
    let items : [ComicItem]?
    let returned : Int?
    
    enum CodingKeys: String, CodingKey {
        case available = "available"
        case collectionURI = "collectionURI"
        case items = "items"
        case returned = "returned"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        available = try values.decodeIfPresent(Int.self, forKey: .available)
        collectionURI = try values.decodeIfPresent(String.self, forKey: .collectionURI)
        items = try values.decodeIfPresent([ComicItem].self, forKey: .items)
        returned = try values.decodeIfPresent(Int.self, forKey: .returned)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(available, forKey: .available)
        try container.encode(collectionURI, forKey: .collectionURI)
        try container.encode(items, forKey: .items)
        try container.encode(returned, forKey: .returned)
    }
}


struct ComicItem: Codable {
    let name : String?
    let resourceURI : String?
    
    enum CodingKeys: String, CodingKey {
        case name = "name"
        case resourceURI = "resourceURI"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        resourceURI = try values.decodeIfPresent(String.self, forKey: .resourceURI)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        try container.encode(resourceURI, forKey: .resourceURI)
    }
}


struct PersonaDataUrls: Codable {
    let type : String?
    let url : String?
    
    enum CodingKeys: String, CodingKey {
        case type = "type"
        case url = "url"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        type = try values.decodeIfPresent(String.self, forKey: .type)
        url = try values.decodeIfPresent(String.self, forKey: .url)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(type, forKey: .type)
        try container.encode(url, forKey: .url)
    }
}


struct PersonaDataImage: Codable {
    let fileExtension: String?
    let path : String?
    
    enum CodingKeys: String, CodingKey {
        case fileExtension = "extension"
        case path = "path"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        fileExtension = try values.decodeIfPresent(String.self, forKey: .fileExtension)
        path = try values.decodeIfPresent(String.self, forKey: .path)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(fileExtension, forKey: .fileExtension)
        try container.encode(path, forKey: .path)
    }
}
