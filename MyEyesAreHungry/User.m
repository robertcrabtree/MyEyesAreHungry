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

-(BOOL)login
{
    @synchronized (self){
        NSLog(@"User:login: [[email=%@, pass=%@]]", self.email, self.pass);
        return [self login:self.email password:self.pass];
    }
}

-(BOOL)login:(NSString *)emailAddress password:(NSString *)password
{
    @synchronized (self){
        NSLog(@"User:login: email=%@, pass=%@", emailAddress, password);
        BOOL success = NO;
         
        NSURL *url = [NSURL URLWithString:@"http://www.myeyesarehungry.com/api/login.php"];
        ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:url];
        
        [request setPostValue:emailAddress forKey:@"email"];
        [request setPostValue:password forKey:@"password"];
        [request setPostValue:@"submit" forKey:@"submit"];
        [request setPostValue:@"stay_logged" forKey:@"yes"];
        [request startSynchronous];
        
        if ((![request error]) && ([request responseStatusCode] < 400)) {
            NSDictionary *dict = [request responseHeaders];
            NSString *username = [dict objectForKey:@"X-Login-Name"];
            
            if (username && ![username isEqualToString:@""]) {
                NSString *identity = [dict objectForKey:@"X-Login-Id"];
                
                if (identity && ![identity isEqualToString:@""]) {
                    self.email = emailAddress;
                    self.pass = password;
                    self.user = username;
                    self.ident = identity;
                    [self store];
                    NSLog(@"User:login: user=%@, ident=%@", self.user, self.ident);
                    success = YES;
                } else {
                    NSLog(@"User error: missing id in header");
                }
            } else {
                NSLog(@"User error: missing username in header");
            }
        } else {
            NSLog(@"User error: login request failure");
        }
        [request release];
        
        if (!success)
            [self clear];

        return success;
    }
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
