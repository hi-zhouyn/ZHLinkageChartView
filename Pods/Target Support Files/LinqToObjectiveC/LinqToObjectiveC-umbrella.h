#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "LinqToObjectiveC.h"
#import "NSArray+LinqExtensions.h"
#import "NSDictionary+LinqExtensions.h"

FOUNDATION_EXPORT double LinqToObjectiveCVersionNumber;
FOUNDATION_EXPORT const unsigned char LinqToObjectiveCVersionString[];

