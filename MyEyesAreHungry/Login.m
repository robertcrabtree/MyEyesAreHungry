//
//  Login.m
//  MyEyesAreHungry
//
//  Created by bobby on 8/7/11.
//  Copyright 2011 self. All rights reserved.
//

#import "Login.h"
#import "ASIFormDataRequest.h"

@implementation Login

static NSString *token = nil;

+(NSString *) loginWithUsername:(NSString *) username andPassword:(NSString *) password
{
    NSURL *url = [NSURL URLWithString:@"http://www.myeyesarehungry.com/api/login.php"];
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:url];
    
    [request setPostValue:username forKey:@"email"];
    [request setPostValue:password forKey:@"password"];
    [request setPostValue:@"submit" forKey:@"submit"];
    [request setPostValue:password forKey:@"password"];
    [request setPostValue:@"stay_logged" forKey:@"yes"];
    [request startSynchronous];

    if ((![request error]) && ([request responseStatusCode] < 400)) {
        NSDictionary *dict = [request responseHeaders];
        NSString *val = [dict objectForKey:@"X-Sample-Test"];
        
        if (val && ![val isEqualToString:@""]) {
            if (token)
                [token release];
            token = [val retain];
        }
    }
    
    [request release];
    
    return token;
}

+(void) logout
{
    [ASIHTTPRequest clearSession];
    [ASIFormDataRequest clearSession];
    NSURL *url = [NSURL URLWithString:@"http://www.myeyesarehungry.com/logout.php"];
    ASIFormDataRequest *request = [[ASIFormDataRequest  alloc]  initWithURL:url];
    [request startSynchronous];
    [request release];
}

+(NSString *) userToken
{
    return token;
}

@end
