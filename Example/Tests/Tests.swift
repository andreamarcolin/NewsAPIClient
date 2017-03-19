import UIKit
import XCTest
@testable import NewsAPIClient

class Tests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testSourceInitialization() {
        
        let id = "bbc-news"
        let name = "BBC News"
        let description = "Use BBC News for up-to-the-minute news, breaking news, video, audio and feature stories. BBC News provides trusted World and UK news as well as local and regional perspectives. Also entertainment, business, science, technology and health news."
        let url = "http://www.bbc.co.uk/news"
        let category = "general"
        let language = "en"
        let country = "gb"
        let logoUrls = ["small" : "http://i.newsapi.org/bbc-news-s.png",
                        "medium" : "http://i.newsapi.org/bbc-news-m.png",
                        "large" : "http://i.newsapi.org/bbc-news-l.png"]
        let availableSortBys = ["top"]
        
        let source = NewsAPIClient.Source(id: id,
                                          name: name,
                                          description: description,
                                          url: url,
                                          category: category,
                                          language: language,
                                          country: country,
                                          logoUrls: logoUrls,
                                          availableSortBys: availableSortBys)
        
        XCTAssertEqual(source.id, "bbc-news")
        XCTAssertEqual(source.name, "BBC News")
        XCTAssertEqual(source.description, "Use BBC News for up-to-the-minute news, breaking news, video, audio and feature stories. BBC News provides trusted World and UK news as well as local and regional perspectives. Also entertainment, business, science, technology and health news.")
        XCTAssertEqual(source.url, "http://www.bbc.co.uk/news")
        XCTAssertEqual(source.category, "general")
        XCTAssertEqual(source.language, "en")
        XCTAssertEqual(source.country, "gb")
        XCTAssertEqual(source.logoUrls, ["small" : "http://i.newsapi.org/bbc-news-s.png",
                                         "medium" : "http://i.newsapi.org/bbc-news-m.png",
                                         "large" : "http://i.newsapi.org/bbc-news-l.png"])
        XCTAssertEqual(source.availableSortBys, ["top" : "top"])
    }
    
    func testArticleInitialization() {
        
        let sourceId = "the-next-web"
        let author = "Arno Nijhof"
        let title = "The hunt for the fastest growing company of Europe starts now"
        let description = "Tech5 is a competition in which TNW and Adyen search for the fastest growing tech companies to celebrate their growth. Companies can apply from 1 January."
        let url = "http://thenextweb.com/insider/2017/01/03/the-hunt-for-the-fastest-growing-company-of-europe-starts-now/"
        let urlToImage = "https://cdn3.tnwcdn.com/wp-content/blogs.dir/1/files/2016/12/Banner-Tech5.png"
        let publishedAt = "2017-01-03T08:49:12Z"
        
        do {
            let article = try NewsAPIClient.Article(sourceId: sourceId,
                                                author: author,
                                                title: title,
                                                description: description,
                                                url: url,
                                                urlToImage: urlToImage,
                                                publishedAt: publishedAt)
            XCTAssertEqual(article.sourceId, "the-next-web")
            XCTAssertEqual(article.author, "Arno Nijhof")
            XCTAssertEqual(article.title, "The hunt for the fastest growing company of Europe starts now")
            XCTAssertEqual(article.description, "Tech5 is a competition in which TNW and Adyen search for the fastest growing tech companies to celebrate their growth. Companies can apply from 1 January.")
            XCTAssertEqual(article.url, "http://thenextweb.com/insider/2017/01/03/the-hunt-for-the-fastest-growing-company-of-europe-starts-now/")
            XCTAssertEqual(article.urlToImage, "https://cdn3.tnwcdn.com/wp-content/blogs.dir/1/files/2016/12/Banner-Tech5.png")
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
            XCTAssertEqual(article.publishedAt, dateFormatter.date(from: "2017-01-03T08:49:12Z"))
            
        } catch {
            XCTFail("Unexpected error on Article initialization")
        }
    }
    
    func testArticleInitializationFail() {
        let sourceId = "the-next-web"
        let author = "Arno Nijhof"
        let title = "The hunt for the fastest growing company of Europe starts now"
        let description = "Tech5 is a competition in which TNW and Adyen search for the fastest growing tech companies to celebrate their growth. Companies can apply from 1 January."
        let url = "http://thenextweb.com/insider/2017/01/03/the-hunt-for-the-fastest-growing-company-of-europe-starts-now/"
        let urlToImage = "https://cdn3.tnwcdn.com/wp-content/blogs.dir/1/files/2016/12/Banner-Tech5.png"
        let publishedAt = "badDate"
        
        XCTAssertThrowsError(try NewsAPIClient.Article(sourceId: sourceId,
                                                   author: author,
                                                   title: title,
                                                   description: description,
                                                   url: url,
                                                   urlToImage: urlToImage,
                                                   publishedAt: publishedAt))
    }
    
    func testWrongAPIKey() {
        
        let badApiKey = "badApiKey"
        let client = NewsAPIClient(apiKey: badApiKey)
        
        client.getSources { (sources, error) in
            XCTAssertNil(sources)
            XCTAssertNotNil(error)
        }
        
    }
    
    // FIXME: tests not working on Travis CI 
    // cause: "fatal error: unexpectedly found nil while unwrapping optional value"
    /*
    func testGetSources() {
        
        let apiKey = "5f91ae4f530f453b88c331b7a33a331e"
        let client = NewsAPIClient(apiKey: apiKey)
        
        self.measure {
            client.getSources { (sources, error) in
                XCTAssertNil(error)
                XCTAssertNotNil(sources)
            }
        }
    }
 
    func testGetArticles() {
        let apiKey = "5f91ae4f530f453b88c331b7a33a331e"
        let client = NewsAPIClient(apiKey: apiKey)
        
        self.measure {
            client.getSources { (sources, error) in
                XCTAssertNil(error)
                XCTAssertNotNil(sources)
                
                client.getArticles(sourceId: sources![0].id,
                                   sortBy: sources![0].availableSortBys["latest"])
                { (articles, error) in
                    XCTAssertNil(error)
                    XCTAssertNotNil(articles)
                }
            }
        }
    }
    */
}
