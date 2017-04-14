# STWeakTimer

[![Version](https://img.shields.io/cocoapods/v/STWeakTimer.svg?style=flat)](http://cocoapods.org/pods/STWeakTimer)
[![License](https://img.shields.io/cocoapods/l/STWeakTimer.svg?style=flat)](http://cocoapods.org/pods/STWeakTimer)
[![Platform](https://img.shields.io/cocoapods/p/STWeakTimer.svg?style=flat)](http://cocoapods.org/pods/STWeakTimer)

## An alternative to NSTimer.
STWeakTimer is an alternative to NSTimer, it does not cause the retain cycle, it is thread-safe.

## Requirements

- iOS 8.0 or later (For iOS 8.0 before, maybe it can work, but I have not tested.)
- ARC

## Installation

STWeakTimer is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'STWeakTimer'
```

## Usage

### Import headers in your source files

In the source files where you need to use the library, import the header file:

```objective-c
#import <STWeakTimer/STWeakTimer.h>
```

## Author

Suta, shien7654321@163.com


## License

[MIT]: http://www.opensource.org/licenses/mit-license.php
[MIT license][MIT].