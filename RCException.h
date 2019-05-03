//
//  RCException.h
//
//  Created by Michael Rockhold on 7/28/10.
//  Copyright 2010 The Rockhold Company. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RCException : NSException
{
}

// This method takes a nil-terminated list of objects, and returns an autoreleased RCError
+(RCException*)rcExceptionWithSubDomain:(NSString*)subDomain erroMsgKey:(NSString*)errorMsgKey,...;

+(RCException*)rcExceptionWithSubDomain:(NSString*)subDomain erroMsgKey:(NSString*)errorMsgKey args:(NSArray*)args;

-(id)initWithSubDomain:(NSString*)subDomain erroMsgKey:(NSString*)errorMsgKey args:(NSArray*)args;

@end
