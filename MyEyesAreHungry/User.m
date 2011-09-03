//
//  User.m
//  MyEyesAreHungry
//
//  Created by bobby on 9/1/11.
//  Copyright 2011 self. All rights reserved.
//

#import "User.h"
#import "SFHFKeychainUtils.h"
#import "ASIFormDataRequest.h"

static User *sharedInstance = nil;
NSString *SERVICE = @"MyEyesAreHungry";

@implementation User

@synthesize email, pass, user, ident;
@synthesize selectorSuccess, selectorFailNetwork, selectorFailCredentials, target;

+ (User *)sharedUser
{
    @synchronized (self){
        if (sharedInstance == nil) {
            [[self alloc] init];
        }
    }
    return sharedInstance;
}

+ (id)allocWithZone:(NSZone *)zone
{
    @synchronized (self){
        if (sharedInstance == nil) {
            sharedInstance = [super allocWithZone:zone];
            return sharedInstance;
        }
    }
    return nil;
}

-(BOOL)query
{
    NSError *error;
    NSString *data = [SFHFKeychainUtils getPasswordForUsername:SERVICE andServiceName:SERVICE error:&error];
    
    if (error == nil && data != nil) {
        // parse username and password, separated by a space
        NSArray *array = [data componentsSeparatedByString:@" "];
        if (array.count == 4) {
            self.email = [array objectAtIndex:0];
            self.pass = [array objectAtIndex:1];
            self.user = [array objectAtIndex:2];
            self.ident = [array objectAtIndex:3];
            NSLog(@"User:query email=%@, pass=%@, user=%@, ident=%@",
                  self.email, self.pass, self.user, self.ident);
            return YES;
        }
    }
    
    NSLog(@"User:query <empty>");
    return NO;
}

-(void)store
{
    NSString *data = [NSString stringWithFormat:@"%@ %@ %@ %@",
                     self.email, self.pass, self.user, self.ident, nil];
    NSError *error;
    
    // store user and pass in keychain
    [SFHFKeychainUtils storeUsername:SERVICE andPassword:data forServiceName:SERVICE updateExisting:YES error:&error];
}

- (id)init
{
    @synchronized (self){
        if (!(self = [super init]))
            return nil;
        
        self.email = nil;
        self.pass = nil;
        self.user = nil;
        self.ident = nil;
        
        [self query]; // load data from keychain
         
        return self;
    }
}

-(void)clear
{
    NSError *error;
    [SFHFKeychainUtils deleteItemForUsername:SERVICE andServiceName:SERVICE error:&error];
    
    self.email = nil;
    self.pass = nil;
    self.user = nil;
    self.ident = nil;
}

-(UserLoginStatus)parseResponseHeaders:(ASIHTTPRequest *)request
{
    UserLoginStatus status = USER_LOGIN_SUCCESS;
    
    NSDictionary *dict = [request responseHeaders];
    NSString *username = [dict objectForKey:@"X-Login-Name"];
    
    if ((![request error]) && ([request responseStatusCode] < 400)) {
        if (username && ![username isEqualToString:@""]) {
            NSString *identity = [dict objectForKey:@"X-Login-Id"];
            
            if (identity && ![identity isEqualToString:@""]) {
                self.user = username;
                self.ident = identity;
                [self store];
                status = USER_LOGIN_SUCCESS;
                NSLog(@"User:parseResponseHeaders: user=%@, ident=%@", self.user, self.ident);
            } else {
                NSLog(@"User error: missing id in header");
                status = USER_LOGIN_FAIL_CREDENTIALS;
            }
        } else {
            NSLog(@"User error: missing username in header");
            status = USER_LOGIN_FAIL_CREDENTIALS;
        }
    } else {
        NSLog(@"User error: login request failure");
        status = USER_LOGIN_FAIL_NETWORK;
    }
    
    return status;
}

-(UserLoginStatus)login
{
    @synchronized (self){
        return [self login:self.email password:self.pass async:(BOOL)NO];
    }
}

-(UserLoginStatus)login:(NSString *)emailAddress password:(NSString *)password async:(BOOL)async
{
    @synchronized (self){
        NSLog(@"User:login: email=%@, pass=%@", emailAddress, password);
        UserLoginStatus status = USER_LOGIN_SUCCESS;
         
        NSURL *url = [NSURL URLWithString:@"http://www.myeyesarehungry.com/api/login.php"];
        ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:url];
        
        self.email = emailAddress;
        self.pass = password;

        [request setPostValue:emailAddress forKey:@"email"];
        [request setPostValue:password forKey:@"password"];
        [request setPostValue:@"submit" forKey:@"submit"];
        [request setPostValue:@"stay_logged" forKey:@"yes"];
        
        if (async) {
            [request setDelegate:self];
            [request startAsynchronous];
        } else {
            [request startSynchronous];
            
            status = [self parseResponseHeaders:request];
            [request release];
            
            if (status != USER_LOGIN_SUCCESS)
                [self clear];
        }
        
        return status;
    }
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    UserLoginStatus status = [self parseResponseHeaders:request];
    [request release];
    
    switch (status) {
        case USER_LOGIN_FAIL_CREDENTIALS:
            [self clear];
            [target performSelector:selectorFailCredentials];
            break;
        case USER_LOGIN_FAIL_NETWORK:
            [self clear];
            [target performSelector:selectorFailNetwork];
            break;

        default:
            [target performSelector:selectorSuccess];
            break;
    }
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    [request release];
    [self clear];
    [target performSelector:selectorFailNetwork];
}


-(void)logout
{
    @synchronized (self){
        NSLog(@"logout");
        NSURL *url = [NSURL URLWithString:@"http://www.myeyesarehungry.com/logout.php"];
        ASIFormDataRequest *request = [[ASIFormDataRequest  alloc]  initWithURL:url];
        [request startSynchronous];
        
        [ASIHTTPRequest clearSession];
        [ASIFormDataRequest clearSession];
        
        [request release];
        
        [self clear];
    }
}

-(BOOL)isValid
{
    @synchronized (self){
        return self.email != nil;
    }
}

- (void)release
{
    // do nothing
}


@end
