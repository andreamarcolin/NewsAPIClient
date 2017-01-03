//
//  Source.swift
//  NewsAPIClient
//
//  Created by Andrea Marcolin (Twitter @andreamarcolin5) on 14/12/16.
//  Some rights reserved: http://opensource.org/licenses/MIT
//

import Foundation

public extension NewsAPIClient {
    
    /// A struct which represents a Source entity from NewsAPI.org APIs
    public struct Source {
        
        public let id: String
        public let name: String
        public let description: String
        public let url: String
        public let category: String
        public let language: String
        public let country: String
        public let logoUrls: [String : String]
        public let availableSortBys: [String]
        
        /// The init method for Source
        ///
        /// - Parameters:
        ///   - id: the unique identifier for the news source. This is needed when querying the /articles endpoint to retrieve article metadata
        ///   - name: the display-friendly name of the news source
        ///   - description: a brief description of the news source and what area they specialize in
        ///   - url: the base URL or homepage of the source
        ///   - category: the topic category that the source focuses on
        ///   - language: the 2-letter ISO-639-1 code for the language that the source is written in
        ///   - country: the 2-letter ISO 3166-1 code of the country that the source mainly focuses on
        ///   - logoUrls: an array containing URLs to the source's logo, in different sizes
        ///   - availableSortBys: the available headline lists for the news source
        /// - Throws: an InitializationError if somthing fails during properties initialization (eg. invalid URLs or unknown languages, categories and countries)
        init(id: String, name: String, description: String, url: String, category: String, language: String, country: String, logoUrls: [String : String], availableSortBys: [String]) {
            
            // Assign the parsed objects to struct properties
            self.id = id
            self.name = name
            self.description = description
            self.url = url
            self.category = category
            self.language = language
            self.country = country
            self.logoUrls = logoUrls
            self.availableSortBys = availableSortBys
        }
    } 
}

