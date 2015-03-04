Gingko [![Build Status](https://travis-ci.org/jcccn/Gingko.png)](https://travis-ci.org/jcccn/Gingko)
======

Gingko is a framework wrapper around mobile platforms and businesses of mobile Internet.


## Installation with CocoaPods
[CocoaPods](http://cocoapods.org) is a dependency manager for Objective-C, which automates and simplifies the process of using 3rd-party libraries like AFNetworking in your projects.

To install Gingko with CocoaPods, the private CocoaPods repo [jcccn](https://github.com/jcccn/PodSpecs.git) must be configured.

For example, an available Podfile could be like this:

```ruby
# The front repo is prior if conflicted
# [REQUIRED]CocoaPods private repo
source 'https://github.com/jcccn/PodSpecs.git'
# CocoaPods master repo
source 'https://github.com/CocoaPods/Specs.git'

platform :ios,'7.0'

# ignore all warnings from all pods
inhibit_all_warnings!

pod 'AFNetworking'

pod 'Gingko'

```

## Contact

- [Jiang Chuncheng](https://github.com/jcccn) ([@蒋春成](http://weibo.com/jcccn))

## License

Gingko is available under the MIT license. See the LICENSE file for more info.

