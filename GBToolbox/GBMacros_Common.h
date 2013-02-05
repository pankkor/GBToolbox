//
//  GBMacros.h
//  GBToolbox
//
//  Created by Luka Mirosevic on 11/09/2012.
//  Copyright (c) 2012 Luka Mirosevic. All rights reserved.
//

#ifndef Macros_Common_h
#define Macros_Common_h

//Variadic macros
#define __NARGS(unused, _1, _2, _3, _4, _5, VAL, ...) VAL
#define NARGS(...) __NARGS(unused, ## __VA_ARGS__, 5, 4, 3, 2, 1, 0)

//Logging
#define l(...) NSLog(__VA_ARGS__)

//Localisation
#define _s(string, description) NSLocalizedString(string, description)

//Object instantiation
#define ai(Class) [[Class alloc] init] //might be easier to just use new instead

//Lazy instantiation
#define _lazy(Class, propertyName, ivar) -(Class *)propertyName {if (!ivar) {ivar = [[Class alloc] init];}return ivar;}

//Set
#define _set(...) ([NSSet setWithArray:@[__VA_ARGS__]])

//Resource Bundles
#define _res(bundle, resource) [NSString stringWithFormat:@"%@Resources.bundle/%@", bundle, resource]

//Singleton
#define _singleton(Class, accessor) +(Class *)accessor {static Class *accessor;@synchronized(self) {if (!accessor) {accessor = [[Class alloc] init];}return accessor;}}

//Debugging
#define _b(expression) expression ? @"YES" : @"NO"

//Strings
#define IsEmptyString(string) ((![string isKindOfClass:[NSString class]] || (string == nil) || ([string isEqualToString:@""])) ? YES : NO)
#define IsValidString(string) !IsEmptyString(string)
#define _f(string, ...) ([NSString stringWithFormat:string, __VA_ARGS__])

#endif