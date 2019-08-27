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
    let comics : CItem?
    let series: CItem?
    let stories: CItem?
    let events: CItem?
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
        comics = try values.decodeIfPresent(CItem.self, forKey: .comics)
        events = try values.decodeIfPresent(CItem.self, forKey: .events)
        series = try values.decodeIfPresent(CItem.self, forKey: .series)
        stories = try values.decodeIfPresent(CItem.self, forKey: .stories)
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
        try series?.encode(to: encoder)
        try events?.encode(to: encoder)
        try stories?.encode(to: encoder)
        try container.encode(descriptionField, forKey: .descriptionField)
        try container.encode(id, forKey: .id)
        try container.encode(modified, forKey: .modified)
        try container.encode(name, forKey: .name)
        try container.encode(resourceURI, forKey: .resourceURI)
        try thumbnail?.encode(to: encoder)
        try container.encode(urls, forKey: .urls)
    }
}


struct CItem: Codable {
    let available : Int?
    let collectionURI : String?
    let items : [UriItems]?
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
        items = try values.decodeIfPresent([UriItems].self, forKey: .items)
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


struct UriItems: Codable {
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
    let imageString: String?

    enum CodingKeys: String, CodingKey {
        case fileExtension = "extension"
        case path = "path"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        var fullpath = ""
        if let fileExtension = try values.decodeIfPresent(String.self, forKey: .fileExtension),
            let path = try values.decodeIfPresent(String.self, forKey: .path) {
            fullpath = "\(path).\(fileExtension)"
        }
        imageString = fullpath
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        if let imageStr = imageString {
            let splitedString = imageStr.components(separatedBy: ".")
            try container.encode(splitedString[1], forKey: .fileExtension)
            try container.encode(splitedString[0], forKey: .path)
        }
    }
}

struct ComicsDetails : Codable {
    let creators : CItem?
    let dates : [ComicsDate]?
    let descriptionField : String?
    let diamondCode : String?
    let id : Int?
    let images : [PersonaDataImage]?
    let pageCount : Int?
    let prices : [ComicsPrice]?
    let resourceURI : String?
    let thumbnail : PersonaDataImage?
    let title : String?
    
    enum CodingKeys: String, CodingKey {
        case creators = "creators"
        case dates = "dates"
        case descriptionField = "description"
        case diamondCode = "diamondCode"
        case id = "id"
        case images = "images"
        case pageCount = "pageCount"
        case prices = "prices"
        case resourceURI = "resourceURI"
        case thumbnail = "thumbnail"
        case title = "title"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        creators = try values.decodeIfPresent(CItem.self, forKey: .creators)
        dates = try values.decodeIfPresent([ComicsDate].self, forKey: .dates)
        descriptionField = try values.decodeIfPresent(String.self, forKey: .descriptionField)
        diamondCode = try values.decodeIfPresent(String.self, forKey: .diamondCode)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        images = try values.decodeIfPresent([PersonaDataImage].self, forKey: .images)
        pageCount = try values.decodeIfPresent(Int.self, forKey: .pageCount)
        prices = try values.decodeIfPresent([ComicsPrice].self, forKey: .prices)
        resourceURI = try values.decodeIfPresent(String.self, forKey: .resourceURI)
        thumbnail = try values.decodeIfPresent(PersonaDataImage.self, forKey: .thumbnail)
        title = try values.decodeIfPresent(String.self, forKey: .title)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try creators?.encode(to: encoder)
        try container.encode(dates, forKey: .dates)
        try container.encode(descriptionField, forKey: .descriptionField)
        try container.encode(diamondCode, forKey: .diamondCode)
        try container.encode(id, forKey: .id)
        try images?.encode(to: encoder)
        try container.encode(pageCount, forKey: .pageCount)
        try container.encode(prices, forKey: .prices)
        try container.encode(resourceURI, forKey: .resourceURI)
        try thumbnail?.encode(to: encoder)
        try container.encode(title, forKey: .title)
    }
    
}

struct ComicsPrice : Codable {
    
    let price : Double?
    let type : String?
    
    enum CodingKeys: String, CodingKey {
        case price = "price"
        case type = "type"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        price = try values.decodeIfPresent(Double.self, forKey: .price)
        type = try values.decodeIfPresent(String.self, forKey: .type)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(price, forKey: .price)
        try container.encode(type, forKey: .type)
    }
}

struct ComicsDate : Codable {
    
    let date : String?
    let type : String?
    
    enum CodingKeys: String, CodingKey {
        case date = "date"
        case type = "type"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        date = try values.decodeIfPresent(String.self, forKey: .date)
        type = try values.decodeIfPresent(String.self, forKey: .type)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(date, forKey: .date)
        try container.encode(type, forKey: .type)
    }
}
