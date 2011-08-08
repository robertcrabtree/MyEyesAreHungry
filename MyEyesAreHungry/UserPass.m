//
//  UserPass.m
//  MyEyesAreHungry
//
//  Created by bobby on 8/3/11.
//  Copyright 2011 self. All rights reserved.
//

#import "UserPass.h"
#import "SFHFKeychainUtils.h"

@implementation UserPass

NSString *SERVICE = @"MyEyesAreHungry";

@synthesize username, password;

static UserPass *sharedInstance = nil;

+ (UserPass *)sharedUserPass
{
    @synchronized (self) {
        if (sharedInstance == nil) {
            [[self alloc] init];
        }
    }
    return sharedInstance;
}

+ (id)allocWithZone:(NSZone *)zone
{
    @synchronized(self) {
        if (sharedInstance == nil) {
            sharedInstance = [super allocWithZone:zone];
            return sharedInstance;
        }
    }
    return nil;
}


- (id)init
{
    @synchronized(self) {
        if (!(self = [super init]))
            return nil;
        
        self.username = @"";
        self.password = @"";

        NSError *error;
        NSString *userPass = [SFHFKeychainUtils getPasswordForUsername:SERVICE andServiceName:SERVICE error:&error];
        
        if (error == nil && userPass != nil) {
            // parse username and password, separated by a space
            NSArray *array = [userPass componentsSeparatedByString:@" "];
            if (array.count == 2) {
                self.username = [array objectAtIndex:0];
                self.password = [array objectAtIndex:1];
            }
        }
        return self;
    }
}

- (BOOL)isValid
{
    @synchronized(self) {
        return (![username isEqualToString:@""]) && (![password isEqualToString:@""]);
    }
}

- (BOOL)setUser:(NSString *)user Pass:(NSString *)pass
{
    @synchronized(self) {
        // we need valid strings for user and pass
        if (!user || [user isEqualToString:@""] ||
            !pass || [pass isEqualToString:@""])
            return NO;

        // combine username and password separated by a space
        NSString *str = [NSString stringWithFormat:@"%@%@%@", user, @" ", pass, nil];
        NSError *error;

        // store user and pass in keychain
        BOOL success = [SFHFKeychainUtils storeUsername:SERVICE andPassword:str forServiceName:SERVICE updateExisting:YES error:&error];
        if (success) {
            self.username = user;
            self.password = pass;
        }
        return success;
    }
}

- (BOOL)deleteUser
{
    NSError *error;
    BOOL success = [SFHFKeychainUtils deleteItemForUsername:SERVICE andServiceName:SERVICE error:&error];
    
    if (success) {
        self.username = @"";
        self.password = @"";
    }
    
    return success;
}

- (void)release
{
    // do nothing
}

@end
