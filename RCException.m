//
//  RCException.m
//
//  Created by Michael Rockhold on 7/28/10.
//  Copyright 2010 The Rockhold Company. All rights reserved.
//

#import "RCException.h"

@implementation RCException

+(RCException*)rcExceptionWithSubDomain:(NSString*)subDomain erroMsgKey:(NSString*)errorMsgKey,...
{
	id eachObject;
	va_list argumentList;
	NSMutableArray* args = [NSMutableArray arrayWithCapacity:2];
	
	va_start(argumentList, errorMsgKey);			// Start scanning for arguments after errorMsgKey.
	while (eachObject = va_arg(argumentList, id))	// As many times as we can get an argument of type "id"
		[args addObject: eachObject];               // that isn't nil, add it to self's contents.
	va_end(argumentList);
	
	return [RCException rcExceptionWithSubDomain:subDomain erroMsgKey:errorMsgKey args:args];
}

+(RCException*)rcExceptionWithSubDomain:(NSString*)subDomain erroMsgKey:(NSString*)errorMsgKey args:(NSArray*)args
{
	return [[[RCException alloc] initWithSubDomain:subDomain erroMsgKey:errorMsgKey args:args] autorelease];
}

-(id)initWithSubDomain:(NSString*)subDomain erroMsgKey:(NSString*)errorMsgKey args:(NSArray*)args
{
	NSString* errMsg = nil;
	NSBundle* thisBundle = [NSBundle bundleForClass:[self class]];
	NSString* tableName = [NSString stringWithFormat:@"%@Errors", subDomain];

	if ( args && args.count )
	{
		NSMutableData* buffer = [[[NSMutableData alloc] initWithLength:args.count * sizeof(NSObject*)] autorelease];
		[args getObjects:buffer.mutableBytes range:NSMakeRange(0, args.count)];
		NSString* locString = [thisBundle localizedStringForKey:errorMsgKey value:errorMsgKey table:tableName];
		
		errMsg = [[[NSString alloc] initWithFormat:locString locale:[[NSUserDefaults standardUserDefaults] dictionaryRepresentation] arguments:(va_list)buffer.bytes] autorelease];
	}
	else 
	{
		errMsg = [thisBundle localizedStringForKey:errorMsgKey value:errorMsgKey table:tableName];
	}
	
	self = [super initWithName:[NSString stringWithFormat:@"com.rockholdco.%@", subDomain] reason:errMsg userInfo:nil];
	return self;
}

@end
