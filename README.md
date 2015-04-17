# panorama9-reader
This project is a sample IOS app that demonstrates how to consume Panorama9s public API. The API is documented at http://developer.panorama9.com. Given a valid API key, it will show a list of devices, issues and installed software for a single customer.

The project is intended only as an example and is neither release-ready, nor feature complete. 

Technical details:
 - Written in Swift 1.2
 - Xcode 6.3 required
 - Targeted for the iPhone form factor, iPad should also work.
 - Uses Alamofire (via Cocoapods) for networking. The networking is very simple and NSURLConnection could be easily substituted.
