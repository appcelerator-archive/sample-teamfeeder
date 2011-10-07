/**
 * Appcelerator Titanium Mobile
 * Copyright (c) 2009-2011 by Appcelerator, Inc. All Rights Reserved.
 * Licensed under the terms of the Apache Public License
 * Please see the LICENSE included with this distribution for details.
 * 
 * WARNING: This is generated code. Modify at your own risk and without support.
 */
#import "TiBase.h"
#import "TiApp.h"
#import "TiDebugger.h"

#include <stdarg.h>

NSMutableArray* TiCreateNonRetainingArray() 
{
	CFArrayCallBacks callbacks = kCFTypeArrayCallBacks;
	callbacks.retain = NULL;
	callbacks.release = NULL;
	return (NSMutableArray*)CFArrayCreateMutable(nil, 0, &callbacks);
}

NSMutableDictionary* TiCreateNonRetainingDictionary() 
{
	CFDictionaryKeyCallBacks keyCallbacks = kCFTypeDictionaryKeyCallBacks;
	CFDictionaryValueCallBacks callbacks = kCFTypeDictionaryValueCallBacks;
	callbacks.retain = NULL;
	callbacks.release = NULL;
	return (NSMutableDictionary*)CFDictionaryCreateMutable(nil, 0, &keyCallbacks, &callbacks);
}

CGPoint midpointBetweenPoints(CGPoint a, CGPoint b) 
{
    CGFloat x = (a.x + b.x) / 2.0;
    CGFloat y = (a.y + b.y) / 2.0;
    return CGPointMake(x, y);
}

void TiLogMessage(NSString* str, ...) {
    va_list args;
    va_start(args, str);
    
    NSString* message = [[NSString alloc] initWithFormat:str arguments:args];
    if ([[TiApp app] debugMode]) {
        TiDebuggerLogMessage(OUT, message);
    }
    else {
        const char* s = [message UTF8String];
        if (s[0]=='[')
        {
            fprintf(stderr,"%s\n", s);
            fflush(stderr);
        }
        else
        {
            fprintf(stderr,"[DEBUG] %s\n", s);
            fflush(stderr);
        }
    }

    [message release];
}

NSString * const kTiASCIIEncoding = @"ascii";
NSString * const kTiISOLatin1Encoding = @"ios-latin-1";
NSString * const kTiUTF8Encoding = @"utf8";
NSString * const kTiUTF16Encoding = @"utf16";
NSString * const kTiUTF16LEEncoding = @"utf16le";
NSString * const kTiUTF16BEEncoding = @"utf16be";

NSString * const kTiByteTypeName = @"byte";
NSString * const kTiShortTypeName = @"short";
NSString * const kTiIntTypeName = @"int";
NSString * const kTiLongTypeName = @"long";
NSString * const kTiFloatTypeName = @"float";
NSString * const kTiDoubleTypeName = @"double";

NSString * const kTiContextShutdownNotification = @"TiContextShutdown";
NSString * const kTiWillShutdownNotification = @"TiWillShutdown";
NSString * const kTiShutdownNotification = @"TiShutdown";
NSString * const kTiSuspendNotification = @"TiSuspend";
NSString * const kTiResumeNotification = @"TiResume";
NSString * const kTiResumedNotification = @"TiResumed";
NSString * const kTiAnalyticsNotification = @"TiAnalytics";
NSString * const kTiRemoteDeviceUUIDNotification = @"TiDeviceUUID";
NSString * const kTiGestureShakeNotification = @"TiGestureShake";
NSString * const kTiRemoteControlNotification = @"TiRemoteControl";

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_4_0
NSString * const kTiLocalNotification = @"TiLocalNotification";
#endif

