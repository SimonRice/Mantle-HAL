# Mantle-HAL

[![CI Status](http://img.shields.io/travis/simonrice/Mantle-HAL.svg?style=flat)](https://travis-ci.org/Simon Rice/Mantle-HAL)
[![Version](https://img.shields.io/cocoapods/v/Mantle-HAL.svg?style=flat)](http://cocoapods.org/pods/Mantle-HAL)
[![License](https://img.shields.io/cocoapods/l/Mantle-HAL.svg?style=flat)](http://cocoapods.org/pods/Mantle-HAL)
[![Platform](https://img.shields.io/cocoapods/p/Mantle-HAL.svg?style=flat)](http://cocoapods.org/pods/Mantle-HAL)

Mantle-HAL is a [HAL](http://stateless.co/hal_specification.html) parser for Objective-C.  Unlike other HAL parsers, it sets up strongly typed resources and links for you!

Mantle-HAL runs on top of [Mantle](https://github.com/Mantle/Mantle), a popular JSON model parser that's easy to use and is written and maintained by GitHub!  Like Mantle, Mantle-HAL automatically provides implementations for `<NSCoding>`, `<NSCopying>`, `-isEqual:`, and `-hash`.  If you can use Mantle, you can use Mantle-HAL!

With Mantle-HAL, you can use any http library you wish to use, if any!  The only dependency is Mantle itself.  As a disclaimer, I must state this is an unofficial extension to Mantle itself!

## Getting Started

The easiest way by far of including Mantle-HAL in your project is to use [CocoaPods](http://cocoapods.org).  Once you've got that up & running for your project, simply add `pod "Mantle-HAL"` to your Podfile.

Then run `pod install` to install the dependencies and use the `xcworkspace` from here on.

There is also a small example project that runs on top of [HAL Talk](http://haltalk.herokuapp.com/), along with a few tests based on some common HAL resource examples.

### Resources

At the heart of HAL are resources.  `MTLHALResource` is the base class for all resources in Mantle-HAL.  It contains a dictionary of links, and two further functions to access any embedded resources:

* `- (MTLHALResource *)resourceForRelation:`
* `- (NSArray *)resourcesForRelation:`

Where `relation` is a string containing the key of the embedded relation, as specified in your JSON.

Your resources should subclass `MTLHALResource` and provide your own properties.  

For example, an `Address` resource may look like this:

```objc
 #import <Mantle-HAL/MTLHALResource.h>

 @interface Address : MTLHALResource

 @property (nonatomic, strong) NSString *street;
 @property (nonatomic, strong) NSString *city;
 @property (nonatomic, strong) NSString *state;
 
 @end
```

Now this resource may come from an NSDictionary object representing JSON data.  Converting this dictionary to an address is exactly the same as in Mantle:

```objc
 Address *address = [MTLJSONAdapter modelOfClass:Address.class fromJSONDictionary:addressJSONDictionary error:&error];
```

Now resources can be embedded within different resources.  However, Mantle-HAL allows these embedded resources to be strongly typed as well.  Before converting any HAL resources (e.g., in your App Delegate), you should register your classes to the relevant relations - this is done via `MTLHALResource`'s class method `- registerClass: forRelation:`.  For example, say your resource can have `addr:work` and `addr:home`, both representing Address objects:

```objc
 [MTLHALResource registerClass:Address.class forRelation:@"addr:home"];
 [MTLHALResource registerClass:Address.class forRelation:@"addr:work"];
```

Now whenever you fetch an embedded resource with either of these relations, you will get address objects!

One final important point - if your resource uses `+ JSONKeyPathsByPropertyKey` at all, make sure you include the results of `[super JSONKeyPathsByPropertyKey]` in the dictionary returned - otherwise your links and embedded resources will not be included in your resource.

### Links

HAL resources can contain any number of links.  `MTLHALResource` provides a dictionary called `links`.  The key represents the name of the link and the value is an array of `MTLHALLink` objects.  `MTLHALLink` is an object used to represent a link and fully conforms to the links section of the HAL specification.

### CURIEs

Should you need them, CURIEs are fully supported in Mantle-HAL.  They can be passed down to embedded resources or be overridden.  To get at the CURIE URL for a particular relation, `MTLHALResource` provides `- extendedHrefForRelation:`, which returns the URL containing information about a relation.

## Swift Support

Mantle currently doesn't work with Swift objects, so you'll have to write your resources in Objective-C or prefix your classes with `@objc`.

## Contributions

As everyone says, GitHub is about social coding - I didn't just choose to use it because of my love of git as a version control system.  Please do chip in & help make this an even better project, or even file in an issue if you see anything not working right.

For v1.1, extra credit must be given to @remixnine, who made a number of contibutions and bug fixes.

## License

Usage is provided under the [MIT License](http://opensource.org/licenses/mit-license.php).  See the `LICENSE` file or any class header for the full details.
