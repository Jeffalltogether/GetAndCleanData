## Reading data from API (Applicaiton Programming Interfaces)
# Like Twitter tweets or Facebook feeds
# first you need a Dev account with each website

## create a twitter dev account. and app

library(httr)

## Accessing Twitter from R (NOTE: Keys and Tokens are in "")
myapp = oauth_app("twitter",
                  key= "yourConsumerKeyHere", secret= "yourConsumerSecretHere")
sig = sign_oauth1.0(myapp,
                    token= "yourTokenHere",
                    token_secret= "yourTokenSecretHere")
homeTL = GET("https://api.twitter.com/1.1/statuses/home_timeline.json", sig)

## 
json1 <- content(homeTL)
