//
//  NewsAPIClient.swift
//  NewsAPIClient
//
//  Created by Andrea Marcolin (Twitter @andreamarcolin5) on 14/12/16.
//  Some rights reserved: http://opensource.org/licenses/MIT
//

import Foundation

public class NewsAPIClient {
    
    fileprivate let apiKey: String
    
    /// A client to interact with NewsAPI.org REST APIs
    ///
    /// - Parameter apiKey: the API Key which is needed to sign requests
    public init(apiKey: String) {
        self.apiKey = apiKey
    }
    
    // MARK: - NewsAPI.org API methods
    
    /// Gets all articles for a NewsAPI.org source, optionally ordered by a given criteria
    ///
    /// - Parameters:
    ///   - source: the source id to get all Articles from
    ///   - sortBy: an optional criteria to order the articles by. Since not every Source can be ordered by all the possible criterias, choose between those which are stored in availableSortBys property of the source. Check https://newsapi.org for further details.
    ///   - completionHandler: a closure to be executed after the method completes, to which an array of Article structs (or an error) is passed
    public func getArticles(sourceId: String, sortBy: String? = "top", completionHandler: @escaping ([Article]?, Error?) -> Void) {
        
        // Build a dictionary of parameters for the request
        let parameters = [Constants.JSONKeys.source : sourceId,
                          Constants.JSONKeys.sortBy : sortBy!,
                          Constants.JSONKeys.apiKey : apiKey]
        
        taskForGetMethod(endpoint: Constants.Endpoints.articles, parameters: parameters) { (result, error) in
            
            guard (error == nil) else {
                completionHandler(nil, error)
                return
            }
            
            // Check if the status is "ok"
            guard let status = result![Constants.JSONKeys.status] as? String, status == Constants.Status.ok else {
                completionHandler(nil, ResponseError.apiError(message: result![Constants.JSONKeys.message] as? String))
                return
            }
            
            // Check if Source Id is present
            guard let sourceId = result![Constants.JSONKeys.source] as? String else {
                completionHandler(nil, ResponseError.noSource)
                return
            }
            
            // Check if articles are present
            guard let articles = result![Constants.JSONKeys.articles] as? [[String:AnyObject]] else {
                completionHandler(nil, ResponseError.noArticles)
                return
            }
            
            // Check for empty articles
            guard !articles.isEmpty else {
                completionHandler(nil, ResponseError.emptyArticles)
                return
            }
            
            // Build the result
            var parsedArticles = [Article]()
            for article in articles {
                
                // Allow empty Author or urlToImage (non-essential fields)
                // This is done because of the high number of articles not containing an author
                let author: String = (article[Constants.JSONKeys.author] as? String) ?? ""
                let urlToImage: String = (article[Constants.JSONKeys.urlToImage] as? String) ?? ""
                
                // Check if everything else is present and in the correct format
                guard let title = article[Constants.JSONKeys.title] as? String,
                    let description = article[Constants.JSONKeys.description] as? String,
                    let url = article[Constants.JSONKeys.url] as? String,
                    let publishedAt = article[Constants.JSONKeys.publishedAt] as? String else {
                    
                    // If one of these fields is not a String, skip the article
                    break
                }
                
                // Initialize a Source object with this source's data
                do {
                    let parsedArticle = try Article(sourceId: sourceId,
                                                    author: author,
                                                    title: title,
                                                    description: description,
                                                    url: url,
                                                    urlToImage: urlToImage,
                                                    publishedAt: publishedAt)
                    parsedArticles.append(parsedArticle)
                } catch let error {
                    completionHandler(nil, error)
                    return
                }
            }
            
            // Everything went good, return the parsed sources with no error
            completionHandler(parsedArticles, nil)
        }
    }
    
    /// Gets all news sources supported by NewsAPI.org
    ///
    /// - Parameters:
    ///   - category: the category you would like to get sources for (optional, check supported categories on https://newsapi.org)
    ///   - language: the language you would like to get sources for (optional, check supported languages on https://newsapi.org)
    ///   - country: the country you would like to get sources for (optional, check supported countries on https://newsapi.org)
    ///   - completionHandler: a closure to be executed after the method completes, to which an array of Source structs (or an error) is passed
    public func getSources(category: String? = nil, language: String? = nil, country: String? = nil, completionHandler: @escaping ([Source]?, Error?) -> Void) {
        
        // Build a dictionary of parameters for the request
        var parameters = [String : String]()
        
        if let category = category {
            parameters[Constants.JSONKeys.category] = category
        }
        if let language = language {
            parameters[Constants.JSONKeys.language] = language
        }
        if let country = country {
            parameters[Constants.JSONKeys.country] = country
        }
        
        taskForGetMethod(endpoint: Constants.Endpoints.sources) { (result, error) in
            
            // If there was an error on the URL session task, pass the error through completion handler
            guard (error == nil) else {
                completionHandler(nil, error)
                return
            }
            
            // Check if the status is "ok"
            guard let status = result![Constants.JSONKeys.status] as? String, status == Constants.Status.ok else {
                completionHandler(nil, ResponseError.apiError(message: result![Constants.JSONKeys.message] as? String))
                return
            }
            
            // Check if sources are present
            guard let sources = result![Constants.JSONKeys.sources] as? [[String:AnyObject]] else {
                completionHandler(nil, ResponseError.noSources)
                return
            }
            
            // Check for empty sources
            guard !sources.isEmpty else {
                completionHandler(nil, ResponseError.emptySources)
                return
            }
            
            // Build the result
            var parsedSources = [Source]()
            for source in sources {
                
                // Check if everything is present and in the correct format
                guard let id = source[Constants.JSONKeys.id] as? String,
                    let name = source[Constants.JSONKeys.name] as? String,
                    let description = source[Constants.JSONKeys.description] as? String,
                    let url = source[Constants.JSONKeys.url] as? String,
                    let category = source[Constants.JSONKeys.category] as? String,
                    let language = source[Constants.JSONKeys.language] as? String,
                    let country = source[Constants.JSONKeys.country] as? String,
                    let logoUrls = source[Constants.JSONKeys.urlToLogos] as? [String : String],
                    let availableSortBys = source[Constants.JSONKeys.sortBysAvailable] as? [String]
                else {
                    completionHandler(nil, ResponseError.wrongSourceFormat)
                    return
                }
                
                // Initialize a Source object with this source's data
                parsedSources.append(
                    Source(id: id,
                           name: name,
                           description: description,
                           url: url,
                           category: category,
                           language: language,
                           country: country,
                           logoUrls: logoUrls,
                           availableSortBys: availableSortBys)
                )
            }
            
            // Everything went good, return the parsed sources with no error
            completionHandler(parsedSources, nil)
        }
    }
    
    // MARK: - Helpers
    
    /// Handles the HTTP Request building, execution, parsing of the results and error handling.
    ///
    /// - Parameters:
    ///   - endpoint: the API Method (i.e. the endpoint for the request). Example: "/sources"
    ///   - parameters: a dictionary with all the parameters for the request
    ///   - completionHandler: a closure to be executed when the request is completed, which provides two (mutually exclusive) parameters: a dictionary containing JSON data, or a RequestError
    fileprivate func taskForGetMethod(endpoint: String, parameters: [String: String]? = nil, completionHandler: @escaping ([String:AnyObject]?, Error?) -> Void) {
        
        // Build the URL for the request from parameters and method
        let apiUrl = parseApiUrl(apiMethod: endpoint, parameters: parameters)
        
        // Build the request (defaults to "GET" request)
        let request = URLRequest(url: apiUrl)
        
        // Make the request
        let task = URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
            
            // GUARD: if there was an error with the data Task, just pass the error to the completion handler and return early
            guard (error == nil) else {
                completionHandler(nil, error)
                return
            }
            
            // GUARD: if the the response is invalid or the request was not successful (the response code is not 2xx),
            // pass a custom error to the completion handler and return early
            if let statusCode = (response as? HTTPURLResponse)?.statusCode {
                guard statusCode >= 200 && statusCode <= 299 else {
                    completionHandler(nil, RequestError.unsuccessfulRequest(statusCode: statusCode))
                    return
                }
            } else {
                completionHandler(nil, RequestError.invalidResponse)
                return
            }
            
            
            // GUARD: If no data was returned, send
            guard let data = data else {
                completionHandler(nil, RequestError.noData)
                return
            }
            
            // Try to parse data. If this fails, pass the error to
            var parsedResult: [String:AnyObject]!
            do {
                parsedResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String:AnyObject]
            } catch {
                completionHandler(nil, RequestError.failedToParseJSON)
                return
            }
            
            completionHandler(parsedResult, nil)
        })
        
        // Start the request
        task.resume()
    }
    
    /// Builds the URL for a GET Request with the API method and eventually some parameters
    ///
    /// - Parameters:
    ///   - apiMethod: the API Method (i.e. the endpoint for the request)
    ///   - parameters: a dictionary with all the parameters for the request
    /// - Returns: the built URL for the request
    fileprivate func parseApiUrl(apiMethod: String, parameters: [String : String]?) -> URL {
        
        var components = URLComponents()
        components.scheme = Constants.URL.scheme
        components.host = Constants.URL.host
        components.path = Constants.URL.path + apiMethod
        
        if let parameters = parameters {
            components.queryItems = [URLQueryItem]()
            for (key, value) in parameters {
                let queryItem = URLQueryItem(name: key, value: value)
                components.queryItems!.append(queryItem)
            }
        }
        
        return components.url!
    }
    
    // MARK: - Errors
    
    /// Possible errors which can arise during the HTTP Request
    ///
    /// - invalidResponse: when the web service does not return a valid HTTP Response
    /// - unsuccessfulRequest: when the request is not successful (i.e. the response is not 2xx). The status code of the unsuccessful request is provided as argument
    /// - noData: when no Data is returned by the web service
    /// - failedToParseJSON: when the parsing from Data to JSON fails
    public enum RequestError: Error {
        case invalidResponse
        case unsuccessfulRequest(statusCode: Int)
        case noData
        case failedToParseJSON
    }
    
    /// Possible errors which can be reported by API's response
    ///
    /// - apiError: when the API reports an error due to incorrect parameters or other internal errors
    /// - noSource: when the API does not specify the source id for the provided articles
    /// - noSources: when the API does not include a "sources" object in the response after a request to the Sources endpoint
    /// - noArticles: when the API does not include an "articles" object in the response after a request to the Articles endpoint
    /// - emptySources: when the API responds with an empty array of Sources
    /// - emptyArticles: when the API responds with an empty array of Articles
    /// - wrongSourceFormat: when the API provides data in wrong format for Sources
    /// - wrongArticleFormat: when the API provides data in wrong format for Articles
    public enum ResponseError: Error {
        case apiError(message: String?)
        case noSource
        case noSources
        case noArticles
        case emptySources
        case emptyArticles
        case wrongSourceFormat
    }
}
