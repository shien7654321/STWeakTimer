# STWeakTimer

[![Language](https://img.shields.io/badge/language-ObjC-limegreen.svg?style=flat)](http://cocoapods.org/pods/STWeakTimer)
[![Platform](https://img.shields.io/cocoapods/p/STWeakTimer.svg?style=flat)](http://cocoapods.org/pods/STWeakTimer)
[![Version](https://img.shields.io/cocoapods/v/STWeakTimer.svg?style=flat)](http://cocoapods.org/pods/STWeakTimer)
[![License](https://img.shields.io/cocoapods/l/STWeakTimer.svg?style=flat)](http://cocoapods.org/pods/STWeakTimer)

## An alternative to NSTimer.
STWeakTimer is an alternative to NSTimer, it does not cause the retain cycle, it is thread-safe.

![STWeakTimerPreview01](https://github.com/shien7654321/STWeakTimer/raw/master/Preview/STWeakTimerPreview01.gif)

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

### Initialize STWeakTimer

Initialize a STWeakTimer, you can use a selector or block as the callback. You can also set the thread to execute the callback:

```objective-c
STWeakTimer *timer = [STWeakTimer scheduledTimerWithTimeInterval:1 userInfo:nil repeats:YES dispatchQueue:dispatch_get_main_queue() handler:^(STWeakTimer * _Nullable timer) {
    NSLog(@"Timer triggered");
}];
```

### Control STWeakTimer

STWeakTimer supports pause and resume:

```objective-c
[timer pause];
```

```objective-c
[timer resume];
```

## Author

Suta, shien7654321@163.com


## License

[MIT]: https://opensource.org/licenses/MIT
[MIT license][MIT].
