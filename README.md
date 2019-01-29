# Treehouse iOS Techdegree - Project 10 - NASA App

[![Swift Version](https://img.shields.io/badge/Swift-4.2.x-orange.svg)](https://swift.org)

## Setup

### NASA API Key

This project requires a NASA API Key. You can apply for one at the [NASA API website](https://api.nasa.gov/index.html#apply-for-an-api-key).

Then add the file `ApiKey.swift` with the contents

```swift
class ApiKey {
    static let nasa = "<api_key>"
}
```

in `NASACapstone/Networking`.

### Carthage

This project relies on [Kingfisher](https://github.com/onevcat/Kingfisher) and the [Facebook Swift SDK](https://github.com/facebook/facebook-swift-sdk). Make sure you are running the latest version of [Carthage](https://github.com/carthage/carthage) by running:

```bash
brew update
brew upgrade carthage
```

**Note:** At the time of writing this, the Facebook Swift SDK is in beta (0.5).
**Note:** Facebook recommends using Carthage version 0.31.1 or later.

`cd` to the Xcode project folder that contains the `Cartfile` then run `carthage update --platform ios`. This should download and build all of the necessary dependencies needed to run this project.

If Carthage doesn't build the `Bolts` framework like it did for me, there's a [workaround](https://github.com/facebook/facebook-swift-sdk/issues/294). `cd` to `Carthage/Checkouts/facebook-sdk-swift` then run `carthage build --no-skip-current --platform ios`.

### Exceeds Expectations

This project has implemented the "Exceeds Expectations" criteria which is

> Create your own custom feature! In order to get an overall "Exceeds" grade for this project, you must implement an additional module. Leverage skills learned in the Techdegree and the NASA API in a meaningful way, plus at least one skill, API, or language feature NOT explicitly covered in the course thus far. Remember to create an additional main area as well for this function. Please provide detailed comment and usage instruction such that the functionality can be reviewed properly, and again, details about any third party libraries that you use.

For this, the NASA APOD [Astronomy Picture of the Day](https://apod.nasa.gov/apod/astropix.html) [API](https://api.nasa.gov/api.html#apod) was used. The user can choose from a collection of thumbnails to see a larger image and details about the image. A Facebook share button can be used in the detail view of the photo.

The Facebook share button is associated with a Facebook Test App and can be tested with a Facebook Test User.