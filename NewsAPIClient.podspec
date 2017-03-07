Pod::Spec.new do |s|
  s.name             = 'NewsAPIClient'
  s.version          = '0.2.3'
  s.summary          = 'NewsAPICLient is a REST Client for NewsAPI.org'
  s.description      = <<-DESC
NewsAPIClient is a REST Client, written in Swift 3.0, which interacts with NewsAPI (https://newsapi.org) to retrieve headlines currently published on a range of news sources and blogs
                       DESC
  s.homepage         = 'https://github.com/andreamarcolin/NewsAPIClient'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'andreamarcolin' => 'andreamarcolin@hotmail.it' }
  s.source           = { :git => 'https://github.com/andreamarcolin/NewsAPIClient.git', :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/andreamarcolin5'
  s.ios.deployment_target = '8.0'
  s.source_files = 'NewsAPIClient/Classes/**/*'
end
