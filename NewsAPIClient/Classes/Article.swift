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
        
        public let sourceId: String
        public let author: String
        public let title: String
        public let description: String
        public let url: String
        public let urlToImage: String
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
        init(sourceId: String, author: String, title: String, description: String, url: String, urlToImage: String, publishedAt: String) throws {
            
            // Parse the publishedAt date as Date, guarding for possible unrecognized values (if it is the case, throw an error and exit early)
            let dateFormatter = DateFormatter()
            
            // Try with different date formats while the suitable one is found
            for format in Constants.Utilities.dateFormats {
                dateFormatter.dateFormat = format
                if let date = dateFormatter.date(from: publishedAt) {
                    // Found a suitable date format
                    // Assign the parsed objects to struct properties
                    self.sourceId = sourceId
                    self.author = author
                    self.title = title
                    self.description = description
                    self.url = url
                    self.urlToImage = urlToImage
                    self.publishedAt = dateFormatter.date(from: publishedAt)!
                    return
                }
            }
            // If we came here, no suitable date format was found, return an errors
            throw InitializationError.invalidPublishedAtDate(invalidPublishedAtDate: publishedAt)
        }
        
        /// The possible errors which can arise on Article struct initilization
        ///
        /// - invalidPublishedAtDate: when a date is not in the correct format (cannot be parsed from String to Date with the format "yyyy-MM-dd'T'HH:mm:ss'Z'")
        public enum InitializationError: Error {
            case invalidPublishedAtDate(invalidPublishedAtDate: String)
        }
    }
}
