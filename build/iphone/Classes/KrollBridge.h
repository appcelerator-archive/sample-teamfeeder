/**
 * Appcelerator Titanium Mobile
 * Copyright (c) 2009-2011 by Appcelerator, Inc. All Rights Reserved.
 * Licensed under the terms of the Apache Public License
 * Please see the LICENSE included with this distribution for details.
 * 
 * WARNING: This is generated code. Modify at your own risk and without support.
 */

#import <Foundation/Foundation.h>
#import "Bridge.h"
#import "Ti.h"
#import "TiEvaluator.h"
#import "TiProxy.h"
#import "KrollContext.h"
#import "KrollObject.h"
#import "TiModule.h"

@interface TeamFeederObject : KrollObject {
@private
	NSMutableDictionary *modules;
	TiHost *host;
	id<TiEvaluator> pageContext;
	NSMutableDictionary *dynprops;
}

-(id)initWithContext:(KrollContext*)context_ host:(TiHost*)host_ context:(id<TiEvaluator>)context baseURL:(NSURL*)baseURL_;
-(KrollObject*)addModule:(NSString*)name module:(TiModule*)module;
-(TiModule*)moduleNamed:(NSString*)name context:(id<TiEvaluator>)context;
@end


@interface KrollBridge : Bridge<TiEvaluator,KrollDelegate> {
@private
	NSURL * currentURL;

	KrollContext *context;
	NSDictionary *preload;
	NSMutableDictionary *modules;
	TeamFeederObject *_teamfeeder;
	BOOL shutdown;
    BOOL evaluationError;
	NSMutableArray *proxies;
	//NOTE: Do NOT treat registeredProxies like a mutableDictionary; mutable dictionaries copy keys,
	//CFMutableDictionaryRefs only retain keys, which lets them work with proxies properly.
	CFMutableDictionaryRef registeredProxies;
	NSCondition *shutdownCondition;
	NSRecursiveLock *proxyLock;
}
- (void)boot:(id)callback url:(NSURL*)url_ preload:(NSDictionary*)preload_;
- (void)evalJSWithoutResult:(NSString*)code;
- (id)evalJSAndWait:(NSString*)code;
- (BOOL)evaluationError;
- (void)fireEvent:(id)listener withObject:(id)obj remove:(BOOL)yn thisObject:(TiProxy*)thisObject;
- (id)preloadForKey:(id)key name:(id)name;
- (KrollContext*)krollContext;

+ (NSArray *)krollBridgesUsingProxy:(id)proxy;
+ (int)countOfKrollBridgesUsingProxy:(id)proxy;
+ (BOOL)krollBridgeExists:(KrollBridge *)bridge;
+ (KrollBridge *)krollBridgeForThreadName:(NSString *)threadName;

-(void)enqueueEvent:(NSString*)type forProxy:(TiProxy *)proxy withObject:(id)obj withSource:(id)source;
-(void)registerProxy:(id)proxy krollObject:(KrollObject *)ourKrollObject;
-(int)forceGarbageCollectNow;

@end

