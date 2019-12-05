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

#import "BaseModel.h"
#import "XNHTTPManage.h"
#import "XNHTTPSessionManager.h"

FOUNDATION_EXPORT double XNNetWorkManagerVersionNumber;
FOUNDATION_EXPORT const unsigned char XNNetWorkManagerVersionString[];

