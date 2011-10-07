/**
 * Appcelerator Titanium Mobile
 * Copyright (c) 2009-2011 by Appcelerator, Inc. All Rights Reserved.
 * Licensed under the terms of the Apache Public License
 * Please see the LICENSE included with this distribution for details.
 * 
 * WARNING: This is generated code. Modify at your own risk and without support.
 */

#import <objc/runtime.h>

#import "TiProxy.h"
#import "TiHost.h"
#import "KrollCallback.h"
#import "KrollContext.h"
#import "KrollBridge.h"
#import "TiModule.h"
#import "ListenerEntry.h"
#import "TiComplexValue.h"
#import "TiViewProxy.h"

//Common exceptions to throw when the function call was improper
NSString * const TiExceptionInvalidType = @"Invalid type passed to function";
NSString * const TiExceptionNotEnoughArguments = @"Invalid number of arguments to function";
NSString * const TiExceptionRangeError = @"Value passed to function exceeds allowed range";


NSString * const TiExceptionOSError = @"The iOS reported an error";


//Should be rare, but also useful if arguments are used improperly.
NSString * const TiExceptionInternalInconsistency = @"Value was not the value expected";

//Rare exceptions to indicate a bug in the _teamfeeder code (Eg, method that a subclass should have implemented)
NSString * const TiExceptionUnimplementedFunction = @"Subclass did not implement required method";



SEL SetterForKrollProperty(NSString * key)
{
	NSString *method = [NSString stringWithFormat:@"set%@%@_:", [[key substringToIndex:1] uppercaseString], [key substringFromIndex:1]];
	return NSSelectorFromString(method);
}

SEL SetterWithObjectForKrollProperty(NSString * key)
{
	NSString *method = [NSString stringWithFormat:@"set%@%@_:withObject:", [[key substringToIndex:1] uppercaseString], [key substringFromIndex:1]];
	return NSSelectorFromString(method);
}

void DoProxyDelegateChangedValuesWithProxy(UIView<TiProxyDelegate> * target, NSString * key, id oldValue, id newValue, TiProxy * proxy)
{
	// default implementation will simply invoke the setter property for this object
	// on the main UI thread
	
	// first check to see if the property is defined by a <key>:withObject: signature
	SEL sel = SetterWithObjectForKrollProperty(key);
	if ([target respondsToSelector:sel])
	{
		id firstarg = newValue;
		id secondarg = [NSDictionary dictionary];
		
		if ([firstarg isKindOfClass:[TiComplexValue class]])
		{
			firstarg = [(TiComplexValue*)newValue value];
			secondarg = [(TiComplexValue*)newValue properties];
		}
		
		if ([NSThread isMainThread])
		{
			[target performSelector:sel withObject:firstarg withObject:secondarg];
		}
		else
		{
			if (![key hasPrefix:@"set"])
			{
				key = [NSString stringWithFormat:@"set%@%@_", [[key substringToIndex:1] uppercaseString], [key substringFromIndex:1]];
			}
			NSArray *arg = [NSArray arrayWithObjects:key,firstarg,secondarg,target,nil];
			[proxy performSelectorOnMainThread:@selector(_dispatchWithObjectOnUIThread:) withObject:arg waitUntilDone:YES];
		}
		return;
	}
	
	sel = SetterForKrollProperty(key);
	if ([target respondsToSelector:sel])
	{
		if ([NSThread isMainThread])
		{
			[target performSelector:sel withObject:newValue];
		}
		else
		{
			[target performSelectorOnMainThread:sel withObject:newValue waitUntilDone:YES modes:[NSArray arrayWithObject:NSRunLoopCommonModes]];
		}
	}
}

void DoProxyDispatchToSecondaryArg(UIView<TiProxyDelegate> * target, SEL sel, NSString *key, id newValue, TiProxy * proxy)
{
	id firstarg = newValue;
	id secondarg = [NSDictionary dictionary];
	
	if ([firstarg isKindOfClass:[TiComplexValue class]])
	{
		firstarg = [(TiComplexValue*)newValue value];
		secondarg = [(TiComplexValue*)newValue properties];
	}
	
	if ([NSThread isMainThread])
	{
		[target performSelector:sel withObject:firstarg withObject:secondarg];
	}
	else
	{
		if (![key hasPrefix:@"set"])
		{
			key = [NSString stringWithFormat:@"set%@%@_", [[key substringToIndex:1] uppercaseString], [key substringFromIndex:1]];
		}
		NSArray *arg = [NSArray arrayWithObjects:key,firstarg,secondarg,target,nil];
		[proxy performSelectorOnMainThread:@selector(_dispatchWithObjectOnUIThread:) withObject:arg waitUntilDone:YES];
	}
}

void DoProxyDelegateReadKeyFromProxy(UIView<TiProxyDelegate> * target, NSString *key, TiProxy * proxy, NSNull * nullValue, BOOL useThisThread)
{
	// use valueForUndefined since this should really come from dynprops
	// not against the real implementation
	id value = [proxy valueForUndefinedKey:key];
	if (value == nil)
	{
		return;
	}
	if (value == nullValue)
	{
		value = nil;
	}

	SEL sel = SetterWithObjectForKrollProperty(key);
	if ([target respondsToSelector:sel])
	{
		DoProxyDispatchToSecondaryArg(target,sel,key,value,proxy);
		return;
	}
	sel = SetterForKrollProperty(key);
	if (![target respondsToSelector:sel])
	{
		return;
	}
	if (useThisThread)
	{
		[target performSelector:sel withObject:value];
	}
	else
	{
		[target performSelectorOnMainThread:sel withObject:value
				waitUntilDone:NO modes:[NSArray arrayWithObject:NSRunLoopCommonModes]];
	}
}

void DoProxyDelegateReadValuesWithKeysFromProxy(UIView<TiProxyDelegate> * target, id<NSFastEnumeration> keys, TiProxy * proxy)
{
	BOOL isMainThread = [NSThread isMainThread];
	NSNull * nullObject = [NSNull null];
	BOOL viewAttached = YES;
		
	NSArray * keySequence = [proxy keySequence];
	
	// assume if we don't have a view that we can send on the 
	// main thread to the proxy
	if ([target isKindOfClass:[TiViewProxy class]])
	{
		viewAttached = [(TiViewProxy*)target viewAttached];
	}
	
	BOOL useThisThread = isMainThread==YES || viewAttached==NO;

	for (NSString * thisKey in keySequence)
	{
		DoProxyDelegateReadKeyFromProxy(target, thisKey, proxy, nullObject, useThisThread);
	}

	
	for (NSString * thisKey in keys)
	{
		if ([keySequence containsObject:thisKey])
		{
			continue;
		}
		DoProxyDelegateReadKeyFromProxy(target, thisKey, proxy, nullObject, useThisThread);
	}
}



@implementation TiProxy

@synthesize pageContext, executionContext;
@synthesize modelDelegate;


#pragma mark Private

-(id)init
{
	if (self = [super init])
	{
#if PROXY_MEMORY_TRACK == 1
		NSLog(@"INIT: %@ (%d)",self,[self hash]);
#endif
		pageContext = nil;
		executionContext = nil;
		pthread_rwlock_init(&listenerLock, NULL);
		pthread_rwlock_init(&dynpropsLock, NULL);
	}
	return self;
}

+(BOOL)shouldRegisterOnInit
{
	return YES;
}

-(id)_initWithPageContext:(id<TiEvaluator>)context
{
	if (self = [self init])
	{
		pageContext = (id)context; // do not retain 
		if([[self class] shouldRegisterOnInit]) // && ![NSThread isMainThread])
		{
			[pageContext registerProxy:self];
			// allow subclasses to configure themselves
		}
		[self _configure];
	}
	return self;
}

-(void)setModelDelegate:(id <TiProxyDelegate>)md
{
    if (modelDelegate != self) {
        RELEASE_TO_NIL(modelDelegate);
    }
    
    if (md != self) {
        modelDelegate = [md retain];
    }
    else {
        modelDelegate = md;
    }
}

-(void)contextWasShutdown:(id<TiEvaluator>)context
{
}

-(void)contextShutdown:(id)sender
{
	id<TiEvaluator> context = (id<TiEvaluator>)sender;

	[self contextWasShutdown:context];
	if(pageContext == context){
		//TODO: Should we really stay bug compatible with the old behavior?
		//I think we should instead have it that the proxy stays around until
		//it's no longer referenced by any contexts at all.
		[self _destroy];
		pageContext = nil;
	}
}

-(void)setExecutionContext:(id<TiEvaluator>)context
{
	// the execution context is different than the page context
	//
	// the page context is the owning context that created (and thus owns) the proxy
	//
	// the execution context is the context which is executing against the context when 
	// this proxy is being touched.  since objects can be referenced from one context 
	// in another, the execution context should be used to resolve certain things like
	// paths, etc. so that the proper context can be contextualized which is different
	// than the owning context (page context).
	//
	executionContext = context; //don't retain
}

-(void)_initWithProperties:(NSDictionary*)properties
{
	[self setValuesForKeysWithDictionary:properties];
}

-(void)_initWithCallback:(KrollCallback*)callback
{
}

-(void)_configure
{
	// for subclasses
}

-(id)_initWithPageContext:(id<TiEvaluator>)context_ args:(NSArray*)args
{
	if (self = [self _initWithPageContext:context_])
	{
		id a = nil;
		int count = [args count];
		
		if (count > 0 && [[args objectAtIndex:0] isKindOfClass:[NSDictionary class]])
		{
			a = [args objectAtIndex:0];
		}
		
		if (count > 1 && [[args objectAtIndex:1] isKindOfClass:[KrollCallback class]])
		{
			[self _initWithCallback:[args objectAtIndex:1]];
		}
		
		if (![NSThread isMainThread] && [self _propertyInitRequiresUIThread])
		{
			[self performSelectorOnMainThread:@selector(_initWithProperties:) withObject:a waitUntilDone:NO];
		}		
		else 
		{
			[self _initWithProperties:a];
		}
	}
	return self;
}

-(void)_destroy
{
	if (destroyed)
	{
		return;
	}
	
	destroyed = YES;
	
#if PROXY_MEMORY_TRACK == 1
	NSLog(@"DESTROY: %@ (%d)",self,[self hash]);
#endif

	NSArray * pageContexts = [KrollBridge krollBridgesUsingProxy:self];
	for (id thisPageContext in pageContexts)
	{
		[thisPageContext unregisterProxy:self];
	}
	
	if (executionContext!=nil)
	{
		executionContext = nil;
	}
	
	// remove all listeners JS side proxy
	pthread_rwlock_wrlock(&listenerLock);
	RELEASE_TO_NIL(listeners);
	pthread_rwlock_unlock(&listenerLock);
	
	pthread_rwlock_wrlock(&dynpropsLock);
	RELEASE_TO_NIL(dynprops);
	pthread_rwlock_unlock(&dynpropsLock);
	
	RELEASE_TO_NIL(listeners);
	RELEASE_TO_NIL(baseURL);
	RELEASE_TO_NIL(krollDescription);
    if (modelDelegate != self) {
        RELEASE_TO_NIL(modelDelegate);
    }
	pageContext=nil;
}

-(BOOL)destroyed
{
	return destroyed;
}

-(void)dealloc
{
#if PROXY_MEMORY_TRACK == 1
	NSLog(@"DEALLOC: %@ (%d)",self,[self hash]);
#endif
	[self _destroy];
	pthread_rwlock_destroy(&listenerLock);
	pthread_rwlock_destroy(&dynpropsLock);
	[super dealloc];
}

-(TiHost*)_host
{
	if (pageContext==nil && executionContext==nil)
	{
		return nil;
	}
	if (pageContext!=nil)
	{
		TiHost *h = [pageContext host];
		if (h!=nil)
		{
			return h;
		}
	}
	if (executionContext!=nil)
	{
		return [executionContext host];
	}
	return nil;
}

-(TiProxy*)currentWindow
{
	return [[self pageContext] preloadForKey:@"currentWindow" name:@"UI"];
}

-(NSURL*)_baseURL
{
	if (baseURL==nil)
	{
		TiProxy *currentWindow = [self currentWindow];
		if (currentWindow!=nil)
		{
			// cache it
			[self _setBaseURL:[currentWindow _baseURL]];
			return baseURL;
		}
		return [[self _host] baseURL];
	}
	return baseURL;
}

-(void)_setBaseURL:(NSURL*)url
{
	if (url!=baseURL)
	{
		RELEASE_TO_NIL(baseURL);
		baseURL = [[url absoluteURL] retain];
	} 
}

-(void)setReproxying:(BOOL)yn
{
	reproxying = yn;
}

-(BOOL)inReproxy
{
	return reproxying;
}


-(BOOL)_hasListeners:(NSString*)type
{
	pthread_rwlock_rdlock(&listenerLock);
	//If listeners is nil at this point, result is still false.
	BOOL result = [[listeners objectForKey:type] intValue]>0;
	pthread_rwlock_unlock(&listenerLock);
	return result;
}

-(void)_fireEventToListener:(NSString*)type withObject:(id)obj listener:(KrollCallback*)listener thisObject:(TiProxy*)thisObject_
{
	TiHost *host = [self _host];
	
	NSMutableDictionary* eventObject = nil;
	if ([obj isKindOfClass:[NSDictionary class]])
	{
		eventObject = [NSMutableDictionary dictionaryWithDictionary:obj];
	}
	else 
	{
		eventObject = [NSMutableDictionary dictionary];
	}
	
	// common event properties for all events we fire.. IF they're undefined.
    if ([eventObject objectForKey:@"type"] == nil) {
        [eventObject setObject:type forKey:@"type"];
    }
    if ([eventObject objectForKey:@"source"] == nil) {
        [eventObject setObject:self forKey:@"source"];
    }
	
	KrollContext* context = [listener context];
	if (context!=nil)
	{
		id<TiEvaluator> evaluator = (id<TiEvaluator>)context.delegate;
		[host fireEvent:listener withObject:eventObject remove:NO context:evaluator thisObject:thisObject_];
	}
}

-(void)_listenerAdded:(NSString*)type count:(int)count
{
	// for subclasses
}

-(void)_listenerRemoved:(NSString*)type count:(int)count
{
	// for subclasses
}

// this method will allow a proxy to return a different object back
// for itself when the proxy serialization occurs from native back
// to the bridge layer - the default is to just return ourselves, however,
// in some concrete implementations you really want to return a different
// representation which this will allow. the resulting value should not be 
// retained
-(id)_proxy:(TiProxyBridgeType)type
{
	return self;
}

#pragma mark Public

-(id<NSFastEnumeration>)allKeys
{
	pthread_rwlock_rdlock(&dynpropsLock);
	id<NSFastEnumeration> keys = [dynprops allKeys];
	pthread_rwlock_unlock(&dynpropsLock);
	
	return keys;
}

/*
 *	In views where the order in which keys are applied matter (I'm looking at you, TableView), this should be
 *  an array of which keys go first, and in what order. Otherwise, this is nil.
 */
-(NSArray *)keySequence
{
	return nil;
}

-(KrollObject *)krollObjectForContext:(KrollContext *)context
{
	KrollBridge * ourBridge = (KrollBridge *)[context delegate];

	if(![ourBridge usesProxy:self])
	{
		NSLog(@"[ERROR] Adding an event listener to a proxy that isn't already in the context!!!");
	}

	return [ourBridge krollObjectForProxy:self];
}

-(BOOL)retainsJsObjectForKey:(NSString *)key
{
	return YES;
}

-(void)rememberProxy:(TiProxy *)rememberedProxy
{
	for (KrollBridge * thisBridge in [KrollBridge krollBridgesUsingProxy:self])
	{
		if(rememberedProxy == self)
		{
			KrollObject * thisObject = [thisBridge krollObjectForProxy:self];
			[thisObject protectJsobject];
			continue;
		}

		if(![thisBridge usesProxy:rememberedProxy])
		{
			continue;
		}
		[[thisBridge krollObjectForProxy:self] noteKeylessKrollObject:[thisBridge krollObjectForProxy:rememberedProxy]];
	}
}


-(void)forgetProxy:(TiProxy *)forgottenProxy
{
	for (KrollBridge * thisBridge in [KrollBridge krollBridgesUsingProxy:self])
	{
		if(forgottenProxy == self)
		{
			KrollObject * thisObject = [thisBridge krollObjectForProxy:self];
			[thisObject unprotectJsobject];
			continue;
		}

		if(![thisBridge usesProxy:forgottenProxy])
		{
			continue;
		}
		[[thisBridge krollObjectForProxy:self] forgetKeylessKrollObject:[thisBridge krollObjectForProxy:forgottenProxy]];
	}
}

-(void)rememberSelf
{
	[self rememberProxy:self];
}

-(void)forgetSelf
{
	[self forgetProxy:self];
}

-(void)setCallback:(KrollCallback *)eventCallback forKey:(NSString *)key
{
	BOOL isCallback = [eventCallback isKindOfClass:[KrollCallback class]]; //Also check against nil.
	KrollBridge * blessedBridge = [[eventCallback context] delegate];
	NSArray * bridges = [KrollBridge krollBridgesUsingProxy:self];

	for (KrollBridge * currentBridge in bridges)
	{
		KrollObject * currentKrollObject = [currentBridge krollObjectForProxy:self];
		if(!isCallback || (blessedBridge != currentBridge))
		{
			[currentKrollObject forgetCallbackForKey:key];
		}
		else
		{
			[currentKrollObject noteCallback:eventCallback forKey:key];
		}
	}

}

-(void)fireCallback:(NSString*)type withArg:(NSDictionary *)argDict withSource:(id)source
{
	NSMutableDictionary* eventObject = [NSMutableDictionary dictionaryWithObjectsAndKeys:type,@"type",self,@"source",nil];
	if ([argDict isKindOfClass:[NSDictionary class]])
	{
		[eventObject addEntriesFromDictionary:argDict];
	}

	NSArray * bridges = [KrollBridge krollBridgesUsingProxy:self];
	for (KrollBridge * currentBridge in bridges)
	{
		KrollObject * currentKrollObject = [currentBridge krollObjectForProxy:self];
		[currentKrollObject invokeCallbackForKey:type withObject:eventObject thisObject:source];
	}
}

-(void)addEventListener:(NSArray*)args
{
	NSString *type = [args objectAtIndex:0];
	KrollCallback* listener = [args objectAtIndex:1];
	ENSURE_TYPE(listener,KrollCallback);

	KrollObject * ourObject = [self krollObjectForContext:[listener context]];
	[ourObject storeListener:listener forEvent:type];

	//TODO: You know, we can probably nip this in the bud and do this at a lower level,
	//Or make this less onerous.
	int ourCallbackCount = 0;

	pthread_rwlock_wrlock(&listenerLock);
	ourCallbackCount = [[listeners objectForKey:type] intValue] + 1;
	if(listeners==nil){
		listeners = [[NSMutableDictionary alloc] initWithCapacity:3];
	}
	[listeners setObject:NUMINT(ourCallbackCount) forKey:type];
	pthread_rwlock_unlock(&listenerLock);

	[self _listenerAdded:type count:ourCallbackCount];
}
	  
-(void)removeEventListener:(NSArray*)args
{
	NSString *type = [args objectAtIndex:0];
	KrollCallback* listener = [args objectAtIndex:1];
	ENSURE_TYPE(listener,KrollCallback);

	KrollObject * ourObject = [self krollObjectForContext:[listener context]];
	[ourObject removeListener:listener forEvent:type];

	//TODO: You know, we can probably nip this in the bud and do this at a lower level,
	//Or make this less onerous.
	int ourCallbackCount = 0;

	pthread_rwlock_wrlock(&listenerLock);
	ourCallbackCount = [[listeners objectForKey:type] intValue] - 1;
	[listeners setObject:NUMINT(ourCallbackCount) forKey:type];
	pthread_rwlock_unlock(&listenerLock);

	[self _listenerRemoved:type count:ourCallbackCount];
}

-(void)fireEvent:(id)args
{
	NSString *type = nil;
	id params = nil;
	if ([args isKindOfClass:[NSArray class]])
	{
		type = [args objectAtIndex:0];
		if ([args count] > 1)
		{
			params = [args objectAtIndex:1];
		}
	}
	else if ([args isKindOfClass:[NSString class]])
	{
		type = (NSString*)args;
	}
	[self fireEvent:type withObject:params withSource:self propagate:YES];
}

-(void)fireEvent:(NSString*)type withObject:(id)obj
{
	[self fireEvent:type withObject:obj withSource:self propagate:YES];
}

-(void)fireEvent:(NSString*)type withObject:(id)obj withSource:(id)source
{
	[self fireEvent:type withObject:obj withSource:source propagate:YES];
}

-(void)fireEvent:(NSString*)type withObject:(id)obj propagate:(BOOL)yn
{
	[self fireEvent:type withObject:obj withSource:self propagate:yn];
}

-(void)fireEvent:(NSString*)type withObject:(id)obj withSource:(id)source propagate:(BOOL)propagate
{
	if (![self _hasListeners:type])
	{
		return;
	}

	//TODO: This can be optimized later on.
	NSMutableDictionary* eventObject = nil;
	if ([obj isKindOfClass:[NSDictionary class]])
	{
		eventObject = [NSMutableDictionary dictionaryWithDictionary:obj];
		[eventObject setObject:type forKey:@"type"];
		[eventObject setObject:source forKey:@"source"];
	}
	else 
	{
		eventObject = [NSMutableDictionary dictionaryWithObjectsAndKeys:type,@"type",source,@"source",nil];
	}

	//Since listeners are now at the object level, we have to wait in line.
	NSArray * bridges = [KrollBridge krollBridgesUsingProxy:self];

	for (KrollBridge * currentBridge in bridges)
	{
		[currentBridge enqueueEvent:type forProxy:self withObject:eventObject withSource:source];
	}
}

- (void)setValuesForKeysWithDictionary:(NSDictionary *)keyedValues
{
	//It's possible that the 'setvalueforkey' has its own plans of what should be in the JS object,
	//so we should do this first as to not overwrite the subclass's setter.
	for (KrollBridge * currentBridge in [KrollBridge krollBridgesUsingProxy:self])
	{
		KrollObject * currentKrollObject = [currentBridge krollObjectForProxy:self];
		for (NSString * currentKey in keyedValues)
		{
			id currentValue = [keyedValues objectForKey:currentKey];

			if([currentValue isKindOfClass:[TiProxy class]] && [currentBridge usesProxy:currentValue])
			{
				[currentKrollObject noteKrollObject:[currentBridge krollObjectForProxy:currentValue] forKey:currentKey];
			}
		}
	}

	NSArray * keySequence = [self keySequence];

	for (NSString * thisKey in keySequence)
	{
		id thisValue = [keyedValues objectForKey:thisKey];
		if (thisValue == nil) //Dictionary doesn't have this key. Skip.
		{
			continue;
		}
		if (thisValue == [NSNull null]) 
		{ 
			//When a null, we want to write a nil.
			thisValue = nil;
		}
		[self setValue:thisValue forKey:thisKey];
	}

	for (NSString * thisKey in keyedValues)
	{
		// don't set if already set above
		if ([keySequence containsObject:thisKey]) continue;
		
		id thisValue = [keyedValues objectForKey:thisKey];
		if (thisValue == nil) //Dictionary doesn't have this key. Skip.
		{
			continue;
		} 
		if (thisValue == [NSNull null]) 
		{ 
			//When a null, we want to write a nil.
			thisValue = nil;
		}
		[self setValue:thisValue forKey:thisKey];
	}
}
 
DEFINE_EXCEPTIONS


-(BOOL)_propertyInitRequiresUIThread
{
	// tell our constructor not to place _initWithProperties on UI thread by default
	return NO;
}

- (id) valueForUndefinedKey: (NSString *) key
{
	if ([key isEqualToString:@"toString"] || [key isEqualToString:@"valueOf"])
	{
		return [self description];
	}
	if (dynprops != nil)
	{
		pthread_rwlock_rdlock(&dynpropsLock);
		// In some circumstances this result can be replaced at an inconvenient time,
		// releasing the returned value - so we retain/autorelease.
		id result = [[[dynprops objectForKey:key] retain] autorelease];
		pthread_rwlock_unlock(&dynpropsLock);
		
		// if we have a stored value as complex, just unwrap 
		// it and return the internal value
		if ([result isKindOfClass:[TiComplexValue class]])
		{
			TiComplexValue *value = (TiComplexValue*)result;
			return [value value];
		}
		return result;
	}
	//NOTE: we need to return nil here since in JS you can ask for properties
	//that don't exist and it should return undefined, not an exception
	return nil;
}

- (void)replaceValue:(id)value forKey:(NSString*)key notification:(BOOL)notify
{
	// used for replacing a value and controlling model delegate notifications
	if (value==nil)
	{
		value = [NSNull null];
	}
	id current = nil;
	if (!ignoreValueChanged)
	{
		pthread_rwlock_wrlock(&dynpropsLock);
		if (dynprops==nil)
		{
			dynprops = [[NSMutableDictionary alloc] init];
		}
		else
		{
			// hold it for this invocation since set may cause it to be deleted
			current = [dynprops objectForKey:key];
			if (current!=nil)
			{
				current = [[current retain] autorelease];
			}
		}
		if ((current!=value)&&![current isEqual:value])
		{
			[dynprops setValue:value forKey:key];
		}
		pthread_rwlock_unlock(&dynpropsLock);
	}
	
	if (notify && self.modelDelegate!=nil)
	{
		[self.modelDelegate propertyChanged:key oldValue:current newValue:value proxy:self];
	}
}

- (void) deleteKey:(NSString*)key
{
	pthread_rwlock_wrlock(&dynpropsLock);
	if (dynprops!=nil)
	{
		[dynprops removeObjectForKey:key];
	}
	pthread_rwlock_unlock(&dynpropsLock);
}

- (void) setValue:(id)value forUndefinedKey: (NSString *) key
{
	if([value isKindOfClass:[KrollCallback class]]){
		[self setCallback:value forKey:key];
		//As a wrapper, we hold onto a krollFunction tuple so that other contexts
		//may access the function.
		KrollFunction * newValue = [[[KrollFunction alloc] init] autorelease];
		[newValue setRemoteBridge:[[value context] delegate]];
		[newValue setRemoteFunction:[value function]];
		value = newValue;
	}

	id current = nil;
	pthread_rwlock_wrlock(&dynpropsLock);
	if (dynprops!=nil)
	{
		// hold it for this invocation since set may cause it to be deleted
		current = [[[dynprops objectForKey:key] retain] autorelease];
		if (current==[NSNull null])
		{
			current = nil;
		}
	}
	else
	{
		dynprops = [[NSMutableDictionary alloc] init];
	}

	id propvalue = value;
	
	if (value == nil)
	{
		propvalue = [NSNull null];
	}
	else if (value == [NSNull null])
	{
		value = nil;
	}
		
	// notify our delegate
	if (current!=value)
	{
        // Remember any proxies set on us so they don't get GC'd
        if ([propvalue isKindOfClass:[TiProxy class]]) {
            [self rememberProxy:propvalue];
        }
		[dynprops setValue:propvalue forKey:key];
		pthread_rwlock_unlock(&dynpropsLock);
		if (self.modelDelegate!=nil)
		{
			[[(NSObject*)self.modelDelegate retain] autorelease];
			[self.modelDelegate propertyChanged:key oldValue:current newValue:value proxy:self];
		}
        if ([current isKindOfClass:[TiProxy class]]) {
            [self forgetProxy:current];
        }
		return; // so we don't unlock twice
	}
	pthread_rwlock_unlock(&dynpropsLock);
}

-(NSDictionary*)allProperties
{
	pthread_rwlock_rdlock(&dynpropsLock);
	NSDictionary* props = [[dynprops copy] autorelease];
	pthread_rwlock_unlock(&dynpropsLock);

	return props;
}

-(id)sanitizeURL:(id)value
{
	if (value == [NSNull null])
	{
		return nil;
	}

	if([value isKindOfClass:[NSString class]])
	{
		NSURL * result = [TiUtils toURL:value proxy:self];
		if (result != nil)
		{
			return result;
		}
	}
	
	return value;
}

#pragma mark Memory Management

-(void)didReceiveMemoryWarning:(NSNotification*)notification
{
	//FOR NOW, we're not dropping anything but we'll want to do before release
	//subclasses need to call super if overriden
}
 
#pragma mark Dispatching Helper

-(void)_dispatchWithObjectOnUIThread:(NSArray*)args
{
	//NOTE: this is called by ENSURE_UI_THREAD_WITH_OBJ and will always be on UI thread when we get here
	id method = [args objectAtIndex:0];
	id firstobj = [args count] > 1 ? [args objectAtIndex:1] : nil;
	id secondobj = [args count] > 2 ? [args objectAtIndex:2] : nil;
	id target = [args count] > 3 ? [args objectAtIndex:3] : self;
	if (firstobj == [NSNull null])
	{
		firstobj = nil;
	}
	if (secondobj == [NSNull null])
	{
		secondobj = nil;
	}
	SEL selector = NSSelectorFromString([NSString stringWithFormat:@"%@:withObject:",method]);
	[target performSelector:selector withObject:firstobj withObject:secondobj];
}

#pragma mark Description for nice toString in JS
 
-(id)toString:(id)args
{
	if (krollDescription==nil) 
	{ 
		// if we have a cached id, use it for our identifier
		NSString *cn = [self valueForUndefinedKey:@"id"];
		if (cn==nil)
		{
			cn = [[self class] description];
		}
		krollDescription = [[NSString stringWithFormat:@"[object %@]",[cn stringByReplacingOccurrencesOfString:@"Proxy" withString:@""]] retain];
	}

	return krollDescription;
}

-(id)description
{
	return [self toString:nil];
}

-(id)toJSON
{
	// this is called in the case you try and use JSON.stringify and an object is a proxy 
	// since you can't serialize a proxy as JSON, just return null
	return [NSNull null];
}

@end
