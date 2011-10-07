/**
 * Appcelerator Titanium Mobile
 * Copyright (c) 2009-2011 by Appcelerator, Inc. All Rights Reserved.
 * Licensed under the terms of the Apache Public License
 * Please see the LICENSE included with this distribution for details.
 * 
 * WARNING: This is generated code. Modify at your own risk and without support.
 */
#ifdef USE_TI_UIIPHONENAVIGATIONGROUP

#import "TiUIiPhoneNavigationGroupProxy.h"
#import "TiUtils.h"
#import "TiWindowProxy.h"
#import "TiUIiPhoneNavigationGroup.h"

@implementation TiUIiPhoneNavigationGroupProxy

-(id)init
{
	if (self = [super init])
	{
		//This is done to insert the top line of the nav bar
		//underneath the bottom line of the status bar.
		layoutProperties.top = TiDimensionPixels(-1);
	}
	return self;
}

-(void)open:(NSArray*)args
{
	TiWindowProxy *window = [args objectAtIndex:0];
	ENSURE_TYPE(window,TiWindowProxy);
	[self rememberProxy:window];

	ENSURE_UI_THREAD(open, args);
	NSDictionary *properties = [args count] > 1 ? [args objectAtIndex:1] : [NSDictionary dictionary];
	[[self view] performSelector:@selector(open:withObject:) withObject:window withObject:properties];
}

-(void)close:(NSArray*)args
{
	if ([args count]>0)
	{
		// we're closing a nav group window
		
		TiWindowProxy *window = [args objectAtIndex:0];
		ENSURE_TYPE(window,TiWindowProxy);
		ENSURE_UI_THREAD(close,args);

		NSDictionary *properties = [args count] > 1 ? [args objectAtIndex:1] : [NSDictionary dictionary];
		[[self view] performSelector:@selector(close:withObject:) withObject:window withObject:properties];
		[self forgetProxy:window];
	}
	else 
	{
		ENSURE_UI_THREAD(close,args);	   
		// we're closing the nav group itself
		[[self view] performSelector:@selector(close)];
		[self detachView];
	}
}

-(UINavigationController*)controller
{
	return [(TiUIiPhoneNavigationGroup*)[self view] controller];
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
	if ([self viewAttached])
	{
		[(TiUIiPhoneNavigationGroup *)[self view] willAnimateRotationToInterfaceOrientation:toInterfaceOrientation duration:duration];
	}
}

-(UIViewController *)childViewController
{
	return nil;
}


@synthesize parentOrientationController;

-(TiOrientationFlags) orientationFlags
{
	UINavigationController * controller = [self controller];
	for (UIViewController * thisVC in [[controller viewControllers] reverseObjectEnumerator])
	{
		if (![thisVC isKindOfClass:[TiViewController class]])
		{
			continue;
		}
		TiWindowProxy * thisProxy = (TiWindowProxy *)[(TiViewController *)thisVC proxy];
		if ([thisProxy conformsToProtocol:@protocol(TiOrientationController)])
		{
			TiOrientationFlags result = [thisProxy orientationFlags];
			if (result != TiOrientationNone)
			{
				return result;
			}
		}
	}
	return TiOrientationNone;
}

-(void)childOrientationControllerChangedFlags:(id <TiOrientationController>)orientationController
{
	WARN_IF_BACKGROUND_THREAD;
	[parentOrientationController childOrientationControllerChangedFlags:self];
}

-(void)windowDidClose
{
	WARN_IF_BACKGROUND_THREAD;
	[[self view] close];
	[super windowDidClose];
}

@end

#endif