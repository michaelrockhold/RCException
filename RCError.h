//
//  RCError.h
//
//  Created by Michael Rockhold on 7/28/10.
//  Copyright 2010 The Rockhold Company. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RCError : NSError
{
	NSArray* _args;
	NSString* _errorMsgKey;
	NSString* _tableName;
}

// This method takes a nil-terminated list of objects, and returns an autoreleased RCError
+(RCError*)rcErrorWithSubdomain:(NSString*)subdomain errorMsgKey:(NSString*)errorMsgKey,...;

+(RCError*)rcErrorWithSubdomain:(NSString*)subdomain errorMsgKey:(NSString*)errorMsgKey args:(NSArray*)args;

-(id)initWithSubdomain:(NSString*)subdomain errorMsgKey:(NSString*)errorMsgKey args:(NSArray*)args;

-(void)log;

@end
