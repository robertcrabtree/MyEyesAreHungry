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

@dynamic username, password;

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
        

        NSError *error;
        NSString *userPass = [SFHFKeychainUtils getPasswordForUsername:SERVICE andServiceName:SERVICE error:&error];
        if (error == nil && userPass != nil) {
            // parse username and password, separated by a space
            NSArray *array = [userPass componentsSeparatedByString:@" "];
            if (array.count == 2) {
                username = [[NSString alloc] initWithString:[array objectAtIndex:0]];
                password = [[NSString alloc] initWithString:[array objectAtIndex:1]];
            } else {
                // initialize to empty string
                username = [[NSString alloc] initWithString:@""];
                password = [[NSString alloc] initWithString:@""];                
            }
        } else {
            // initialize to empty string
            username = [[NSString alloc] initWithString:@""];
            password = [[NSString alloc] initWithString:@""];
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
            if (username)
                [username release];
            if (password)
                [password release];
            username = [[NSString alloc] initWithString:user];
            password = [[NSString alloc] initWithString:pass];
        }
        return success;
    }
}

-(NSString *)username
{
    @synchronized(self) {
        return [username autorelease];
    }
}

-(NSString *)password
{
    @synchronized(self) {
        return [password autorelease];
    }
}

- (void)release
{
    // do nothing
}

@end
