# MTEThreadsafeCollections
A collection of threadsafe replacements of NSMutableArray, NSMutableDictionary and NSMutableSet.
This set is inspired by several similar approaches and classes around the globe. We implemented our own version and just now decided to make it public. Hance its redundancy with similar projects.

## Installation

- use [CocoaPods](http://cocoapods.org)
```
    pod 'MTEThreadsafeCollections'
```
- you can also only use one class by using
```
      pod 'MTEThreadsafeCollections/Array'
    or
      pod 'MTEThreadsafeCollections/Dictionary'
    or
      pod 'MTEThreadsafeCollections/Set'
```
- or download [MTEThreadsafeCollections](https://github.com/mateforevents/MTEThreadsafeCollections/archive/master.zip) the source and drop it in your project

## Usage

you can use MTEThreadsafeArray, MTEThreadsafeSet and MTEThreadsafeDictionary in the same way you'd use NSMutableArray, NSMutableSet or NSMutableDictionary. The most important methods are implemented, NSCoding and NSCopying is working.
The classes are backed up by NSMutableArray/Set/Dictionary instanced, which are accessed only on a concurrent queue. Threadsafety is assured since all writes are encapsulated with dispatch_barrier_async.

## Security Disclosure

If you believe you have identified a security vulnerability with a class, you should report it as soon as possible via email to contact@mateforevents.com. Please do not post it to a public issue tracker.

## License

MTEThreadsafeCollections is released under the MIT license. See LICENSE for details.
