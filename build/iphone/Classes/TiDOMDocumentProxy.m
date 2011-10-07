/**
 * Appcelerator Titanium Mobile
 * Copyright (c) 2009-2011 by Appcelerator, Inc. All Rights Reserved.
 * Licensed under the terms of the Apache Public License
 * Please see the LICENSE included with this distribution for details.
 * 
 * WARNING: This is generated code. Modify at your own risk and without support.
 */
#if defined(USE_TI_XML) || defined(USE_TI_NETWORK)

#import "TiDOMDocumentProxy.h"
#import "TiDOMNodeProxy.h"
#import "TiDOMNodeListProxy.h"
#import "TiUtils.h"

@implementation TiDOMDocumentProxy

#pragma mark internal

-(void)dealloc
{
	[super dealloc];
}

-(BOOL)equals:(id)value
{
	if ([value isKindOfClass:[TiDOMDocumentProxy class]])
	{
		return [value isEqual:self];
	}
	return NO;
}

-(void)parseString:(NSString*)xml
{
	NSError *error = nil;
	GDataXMLDocument * ourDocument = [[GDataXMLDocument alloc] initWithXMLString:xml options:0 error:&error];
	[self setElement:[ourDocument rootElement]];
	if (error!=nil)
	{
		[ourDocument release];
		[self throwException:[error description] subreason:nil location:CODELOCATION];
	}
	[self setDocument:ourDocument];
	[ourDocument release];
}

#pragma mark Public APIs

-(id)documentElement:(id)args
{
	GDataXMLElement *root = [[self document] rootElement];
	return [self makeNode:root context:[self pageContext]];
}

-(id)getElementsByTagName:(id)args
{
	ENSURE_SINGLE_ARG(args,NSString);
	NSError *error = nil;
	NSString *xpath = [NSString stringWithFormat:@"//*[local-name()='%@']",args];
	// see if it's a namespace
	NSRange range = [args rangeOfString:@":"];
	if (range.location!=NSNotFound)
	{
		xpath = [NSString stringWithFormat:@"//*[name()='%@']",args];
	}
	NSArray *nodes = [document nodesForXPath:xpath error:&error];
	if (error==nil && nodes!=nil && [nodes count]>0)
	{
		TiDOMNodeListProxy *proxy = [[[TiDOMNodeListProxy alloc] _initWithPageContext:[self pageContext]] autorelease];
		[proxy setDocument:[self document]];
		[proxy setNodes:nodes];
		return proxy;
	}
	if (error!=nil)
	{
		[self throwException:[error description] subreason:nil location:CODELOCATION];
	}
	return nil;
}

-(id)getElementById:(id)args
{
	ENSURE_SINGLE_ARG(args,NSString);
	NSError *error = nil;
	NSArray *nodes = [[self document] nodesForXPath:[NSString stringWithFormat:@"//*[@id='%@']",args] error:&error];
	if (error==nil && nodes!=nil && [nodes count]>0)
	{
		return [self makeNode: [nodes objectAtIndex: 0] context:[self pageContext]];
	}
	return nil;
}

-(id)evaluate:(id)args
{
	ENSURE_SINGLE_ARG(args,NSString);
	NSError *error = nil;
	NSArray *nodes = [[self document] nodesForXPath:args error:&error];
	if (error==nil && nodes!=nil && [nodes count]>0)
	{
		TiDOMNodeListProxy *proxy = [[[TiDOMNodeListProxy alloc] _initWithPageContext:[self pageContext]] autorelease];
		[proxy setDocument:[self document]];
		[proxy setNodes:nodes];
		return proxy;
	}
	return nil;
}

@end

#endif