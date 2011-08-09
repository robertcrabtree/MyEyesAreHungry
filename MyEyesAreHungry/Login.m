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

+(BOOL) loginWithUsername:(NSString *) username andPassword:(NSString *) password
{
    NSURL *url = [NSURL URLWithString:@"http://www.myeyesarehungry.com/login.php"];
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:url];
    BOOL success;
    
    [request setPostValue:@"test@test.com" forKey:@"email"];
    [request setPostValue:@"test" forKey:@"password"];
    [request setPostValue:@"submit" forKey:@"submit"];
    [request setPostValue:@"test" forKey:@"password"];
    [request setPostValue:@"stay_logged" forKey:@"yes"];
    [request startSynchronous];

    /// @todo need status codes from neil
    if ((![request error]) && ([request responseStatusCode] < 400))
        success = YES;
    else
        success = NO;
    
    [request release];
    return success;
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

@end
