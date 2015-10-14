# MTEThreadsafeCollections
A collection of threadsafe replacements of NSMutableArray, NSMutableDictionary and NSMutableSet

## How To Get Started

- [Download MTEThreadsafeCollections](https://github.com/mateforevents/MTEThreadsafeCollections/archive/master.zip) and drop it in your project
- [CocoaPods](http://cocoapods.org) use

    pod 'MTEThreadsafeCollections'

## Usage

you can use MTEThreadsafeArray, MTEThreadsafeSet and MTEThreadsafeDictionary in the same way you'd use NSMutableArray, NSMutableSet or NSMutableDictionary. The most important methods are implemented, NSCoding and NSCopying is working.
The classes are backed up by a NSMutableArray/Set/Dictionary instance, which is accessed only on a concurrent queue. Threadsafy is assured since all writes are encapsulated with dispatch_barrier_async.

## Security Disclosure

If you believe you have identified a security vulnerability with a class, you should report it as soon as possible via email to contact@mateforevents.com. Please do not post it to a public issue tracker.

## License

AFNetworking is released under the MIT license. See LICENSE for details.