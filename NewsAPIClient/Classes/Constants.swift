//
//  Constants.swift
//  NewsAPIClient
//
//  Created by Andrea Marcolin (Twitter @andreamarcolin5) on 14/12/16.
//  Some rights reserved: http://opensource.org/licenses/MIT
//

import Foundation

extension NewsAPIClient {
    
    /// All the constant Strings used to interact with the API, such as URL components, endpoints and JSON keys
    struct Constants {
        
        /// URL components, such as scheme, host and path, to reach the API
        struct URL {
            static let scheme = "https"
            static let host = "newsapi.org"
            static let path = "/v1"
        }
        
        /// API endpoints
        struct Endpoints {
            static let articles = "/articles"
            static let sources = "/sources"
        }
        
        /// JSON request and response keys
        struct JSONKeys {
            
            // Articles JSON keys
            static let source = "source"
            static let apiKey = "apiKey"
            static let sortBy = "sortBy"
            static let articles = "articles"
            static let author = "author"
            static let title = "title"
            static let urlToImage = "urlToImage"
            static let publishedAt = "publishedAt"
            
            // Sources JSON keys
            static let sources = "sources"
            static let name = "name"
            static let category = "category"
            static let language = "language"
            static let country = "country"
            static let urlToLogos = "urlToLogos"
            static let sortBysAvailable = "sortBysAvailable"
            
            // Common JSON keys
            static let status = "status"
            static let id = "id"
            static let description = "description"
            static let url = "url"
            static let message = "message"
        }
        
        /// Status values
        struct Status {
            static let ok = "ok"
            static let error = "error"
        }
        
        struct Utilities {
            static let dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
        }
    }
}
