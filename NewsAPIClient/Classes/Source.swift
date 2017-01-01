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
        public let url: URL
        public let category: Category
        public let language: Language
        public let country: Country
        public let logoUrls: [LogoSize : URL]
        public let availableSortBys: [SortBy]
        
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
        init(id: String, name: String, description: String, url: String, category: String, language: String, country: String, logoUrls: [String : String], availableSortBys: [String]) throws {
            
            // Parse the parameters as custom enums and objects, guarding for possible unrecognized values (if it is the case, throw an error and exit early)
            guard let parsedUrl = URL(string: url) else { throw InitializationError.invalidSourceUrl(invalidSourceUrl: url) }
            guard let parsedCategory = Category(rawValue: category) else { throw InitializationError.unknownCategory(unknownCategory: category) }
            guard let parsedLanguage = Language(rawValue: language) else { throw InitializationError.unknownLanguage(unknownLanguage: language) }
            guard let parsedCountry = Country(rawValue: country) else { throw InitializationError.unknownCountry(unknownCountry: country) }
            
            var parsedLogoUrls = [LogoSize: URL]()
            for (logoSize, logoUrl) in logoUrls {
                guard let parsedLogoSize = LogoSize(rawValue: logoSize) else { throw InitializationError.unknownLogoSize(unknownLogoSize: logoSize)}
                guard let parsedLogoUrl = URL(string: logoUrl) else { throw InitializationError.invalidLogoUrl(invalidLogoUrl: logoUrl) }
                parsedLogoUrls[parsedLogoSize] = parsedLogoUrl
            }
            
            var parsedAvailableSortBys = [SortBy]()
            for sortBy in availableSortBys {
                guard let parsedSortBy = SortBy(rawValue: sortBy) else { throw InitializationError.unknownSortBy(unknownSortBy: sortBy) }
                parsedAvailableSortBys.append(parsedSortBy)
            }
            
            // Assign the parsed objects to struct properties
            self.id = id
            self.name = name
            self.description = description
            self.url = parsedUrl
            self.category = parsedCategory
            self.language = parsedLanguage
            self.country = parsedCountry
            self.logoUrls = parsedLogoUrls
            self.availableSortBys = parsedAvailableSortBys
        }
        
        /// Describes the known criteria used to sort articles
        ///
        /// - top: the order the articles appear on source homepage
        /// - latest: the chronological order, newest first
        /// - popular: the current most popular or currently trending headlines
        public enum SortBy: String {
            case top = "top"
            case latest = "latest"
            case popular = "popular"
        }
        
        /// Describes the known categories for sources
        ///
        /// - business: Business
        /// - entertainment: Entertainment
        /// - gaming: Gaming
        /// - general: General
        /// - music: Music
        /// - scienceAndNature: Science and Nature
        /// - sport: Sport
        /// - technology: Technology
        public enum Category: String {
            case business = "business"
            case entertainment = "entertainment"
            case gaming = "gaming"
            case general = "general"
            case music = "music"
            case scienceAndNature = "science-and-nature"
            case sport = "sport"
            case technology = "technology"
        }
        
        /// Describes the known languages which sources writes in
        ///
        /// - english: English
        /// - german: German
        /// - french: French
        public enum Language: String {
            case english = "en"
            case german = "de"
            case french = "fr"
        }
        
        /// Describes the known countries which sources focuses on
        ///
        /// - australia: Australia
        /// - germany: Germany
        /// - unitedKingdom: United Kingdom
        /// - india: India
        /// - italy: Italy
        /// - unitedStates: United States of America
        public enum Country: String {
            case australia = "au"
            case germany = "de"
            case unitedKingdom = "gb"
            case india = "in"
            case italy = "it"
            case unitedStates = "us"
        }
        
        /// Describes the known logo sizes
        ///
        /// - small: 200px
        /// - medium: 400px
        /// - large: 600px
        public enum LogoSize: String {
            case small = "small"
            case medium = "medium"
            case large = "large"
        }
        
        /// Possible errors which can arise on Source struct initilization
        ///
        /// - unknownCategory: when a source focuses on an unknown topic category
        /// - unknownLanguage: when a source is written in an unknown language
        /// - unknownCountry: when a source focuses on an unknown country
        /// - unknownLogoSize: when a source logo is provided with an unknown size
        /// - unknownSortBy: when a source can be sorted by an unknown criteria
        /// - invalidSourceUrl: when a source url is invalid (cannot be parsed from String to URL)
        /// - invalidLogoUrl: when a source's logo url is invalid (cannot be parsed from String to URL)
        public enum InitializationError: Error {
            case unknownCategory(unknownCategory: String)
            case unknownLanguage(unknownLanguage: String)
            case unknownCountry(unknownCountry: String)
            case unknownLogoSize(unknownLogoSize: String)
            case unknownSortBy(unknownSortBy: String)
            case invalidSourceUrl(invalidSourceUrl: String)
            case invalidLogoUrl(invalidLogoUrl: String)
        }
    } 
}

