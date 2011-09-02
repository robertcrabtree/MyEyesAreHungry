//
//  User.h
//  MyEyesAreHungry
//
//  Created by bobby on 9/1/11.
//  Copyright 2011 self. All rights reserved.
//

#import <Foundation/Foundation.h>

// class for managing login/logout with server and kechain credentials
@interface User : NSObject {
    NSString *email;
    NSString *pass;
    NSString *user;
    NSString *ident;
    NSObject *lock;
}

@property (nonatomic, retain) NSString *email;
@property (nonatomic, retain) NSString *pass;
@property (nonatomic, retain) NSString *user;
@property (nonatomic, retain) NSString *ident;

// singleton instance method
+ (User *)sharedUser;

// login using existing credentials
-(BOOL)login;

// login with specified credentials and save to keychain
-(BOOL)login:(NSString *)emailAddress password:(NSString *)password;

// logout and remove credentials from keychain
-(void)logout;

// returns YES if credentials stored in keychain
-(BOOL)isValid;

@end
