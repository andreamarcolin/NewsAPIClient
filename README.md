# NewsAPIClient

[![CI Status](http://img.shields.io/travis/andreamarcolin/NewsAPIClient.svg?style=flat)](https://travis-ci.org/andreamarcolin/NewsAPIClient)
[![Version](https://img.shields.io/cocoapods/v/NewsAPIClient.svg?style=flat)](http://cocoapods.org/pods/NewsAPIClient)
[![License](https://img.shields.io/cocoapods/l/NewsAPIClient.svg?style=flat)](http://cocoapods.org/pods/NewsAPIClient)
[![Platform](https://img.shields.io/cocoapods/p/NewsAPIClient.svg?style=flat)](http://cocoapods.org/pods/NewsAPIClient)

## Requirements

iOS 8.0+ 
Swift 3.0+

## Installation

NewsAPIClient is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "NewsAPIClient"
```

## Usage

First, create a client with your NewsAPI.org API Key

```swift
let client = NewsAPIClient(apiKey: "<YOUR_API_KEY>")
```

The client provides two methods to interact with the two API endpoints:

### Sources

Send a request to the "/sources" endpoint to get all sources

```swift
client.getSources { (sources, error) in
    guard let sources = sources else {
        print(error!)
        return
    }
    print(sources)
}
```

Optionally filter the sources by category, language or country

```swift
client.getSources(category: NewsAPIClient.Source.Category.business,
                  language: NewsAPIClient.Source.Language.english,
                  country: NewsAPIClient.Source.Country.unitedStates)
{ (sources, error) in

    guard let sources = sources else {
        print(error!)
        return
    }

    print(sources)
}

```

### Articles

Normally, chain the sources request with an articles request to get articles from a specific source (sortBy is optional)

```swift
client.getSources { (sources, error) in
    guard let sources = sources else {
        print(error!)
        return
    }

    client.getArticles(sourceId: sources[0].id,
                       sortBy: sources[0].availableSortBys["latest"]) // if "latest" is not available for this source, defaults to "top" 
    { (articles, error) in

        guard let articles = articles else {
            print(error!)
            return
        }

        print(articles)
    }
}
```

Otherwise, if you already have a source object (i.e. previously obtained by the source method) just pass it to the getArticles() method to obtain articles for the given source
Remember, sortby is optional, so in this case we provide an example without passing a sortBy.

```swift
client.getArticles(source: source) { (articles, error) in
    guard let articles = articles else {
        print(error!)
        return
    }

    print(articles)
}
```

## Release Notes

Version 0.2.0
* Simplified Article and Source's structure for easier integration

Version 0.1.0
* Initial release

## Author

Andrea Marcolin, andreamarcolin@hotmail.it

## License

NewsAPIClient is available under the MIT license. See the LICENSE file for more info.
