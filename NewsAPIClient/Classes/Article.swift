//
//  Article.swift
//  NewsAPIClient
//
//  Created by Andrea Marcolin (Twitter @andreamarcolin5) on 14/12/16.
//  Some rights reserved: http://opensource.org/licenses/MIT
//

import Foundation

public extension NewsAPIClient {
    
    /// A struct which represents an Article entity from NewsAPI.org APIs
    public struct Article {
        
        public let author: String
        public let title: String
        public let description: String
        public let url: URL
        public let urlToImage: URL
        public let publishedAt: Date
        
        /// The init method for Article
        ///
        /// - Parameters:
        ///   - author: the author of the article
        ///   - title: the headline or title of the article.
        ///   - description: a description or preface for the article (eg. the first part of the body)
        ///   - url: the direct URL to the content page of the article
        ///   - urlToImage: the URL to a relevant image for the article
        ///   - publishedAt: the best attempt at finding a date for the article, in UTC (+0). Format for the date is "yyyy-MM-dd'T'HH:mm:ss'Z'" (eg. "2016-12-16T09:56:38Z")
        /// - Throws: an InitializationError if somthing fails during properties initialization (eg. invalid URLs or date format)
        init(author: String, title: String, description: String, url: String, urlToImage: String, publishedAt: String) throws {
            
            // Parse the parameters as custom enums and objects, guarding for possible unrecognized values (if it is the case, throw an error and exit early)
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = Constants.Utilities.dateFormat
            
            guard let parsedUrl = URL(string: url) else { throw InitializationError.invalidUrl(invalidUrl: url) }
            guard let parsedUrlToImage = URL(string: urlToImage) else { throw InitializationError.invalidImageUrl(invalidImageUrl: urlToImage) }
            guard let parsedPublishedAt = dateFormatter.date(from: publishedAt) else { throw InitializationError.invalidPublishedAtDate(invalidPublshedAtDate: publishedAt) }
            
            // Assign the parsed objects to struct properties
            self.author = author
            self.title = title
            self.description = description
            self.url = parsedUrl
            self.urlToImage = parsedUrlToImage
            self.publishedAt = parsedPublishedAt
        
        }
        
        /// The possible errors which can arise on Article struct initilization
        ///
        /// - invalidUrl: when an article url is invalid (cannot be parsed from String to URL)
        /// - invalidImageUrl: when an article's image url is invalid (cannot be parsed from String to URL)
        /// - invalidPublishedAtDate: when a date is not in the correct format (cannot be parsed from String to Date with the format "yyyy-MM-dd'T'HH:mm:ss'Z'")
        public enum InitializationError: Error {
            case invalidUrl(invalidUrl: String)
            case invalidImageUrl(invalidImageUrl: String)
            case invalidPublishedAtDate(invalidPublshedAtDate: String)
        }
    }
}
