//
//  RCError.m
//
//  Created by Michael Rockhold on 7/28/10.
//  Copyright 2010 The Rockhold Company. All rights reserved.
//

#import "RCError.h"

@implementation RCError

+(RCError*)rcErrorWithSubdomain:(NSString*)subdomain errorMsgKey:(NSString*)errorMsgKey,...
{
	id eachObject;
	va_list argumentList;
	NSMutableArray* args = [NSMutableArray arrayWithCapacity:2];
	
	va_start(argumentList, errorMsgKey);			// Start scanning for arguments after errorMsgKey.
	while (eachObject = va_arg(argumentList, id))	// As many times as we can get an argument of type "id"
		[args addObject: eachObject];               // that isn't nil, add it to self's contents.
	va_end(argumentList);
	
	return [RCError rcErrorWithSubdomain:subdomain errorMsgKey:errorMsgKey args:args];
}

+(RCError*)rcErrorWithSubdomain:(NSString*)subdomain errorMsgKey:(NSString*)errorMsgKey args:(NSArray*)args
{
	return [[[RCError alloc] initWithSubdomain:subdomain errorMsgKey:errorMsgKey args:args] autorelease];
}

-(id)initWithSubdomain:(NSString*)subdomain errorMsgKey:(NSString*)errorMsgKey args:(NSArray*)args
{
	if ( self = [super initWithDomain:[NSString stringWithFormat:@"com.rockholdco.%@", subdomain] code:[errorMsgKey hash] userInfo:nil] )
	{
		_args = [args retain];
		_errorMsgKey = [errorMsgKey retain];
		_tableName = [NSString stringWithFormat:@"%@Errors", subdomain];
	}
	return self;
}

-(void)dealloc
{
	[_args release];
	[_errorMsgKey release];
	[_tableName release];
	[super dealloc];
}

-(NSString*)localizedDescription
{
	if ( _args && _args.count )
	{
		NSMutableData* buffer = [[[NSMutableData alloc] initWithLength:_args.count * sizeof(NSObject*)] autorelease];
		[_args getObjects:buffer.mutableBytes range:NSMakeRange(0, _args.count)];
		NSString* locString = [[NSBundle bundleForClass:[self class]] localizedStringForKey:_errorMsgKey value:_errorMsgKey table:_tableName];
		
		return [[[NSString alloc] initWithFormat:locString locale:[[NSUserDefaults standardUserDefaults] dictionaryRepresentation] arguments:(va_list)buffer.bytes] autorelease];
	}
	else 
	{
		return [[NSBundle bundleForClass:[self class]] localizedStringForKey:_errorMsgKey value:_errorMsgKey table:_tableName];
	}
}

-(NSString*)localizedFailureReason
{
	return nil;
}

-(void)log
{
	NSLog(@"Warning (non-fatal error): %@", [self localizedDescription]);
}

@end
