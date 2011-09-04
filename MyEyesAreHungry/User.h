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
    
    // turns out these selectorys ruin the singleton design pattern
    // but we'll leave this as is anyways. user class clients are responsible
    // for setting these properties prior to each call to login/logout.
    SEL selectorSuccess;
    SEL selectorFailNetwork;
    SEL selectorFailCredentials;
    id target;
    BOOL loggingIn;
}

typedef enum UserLoginStatus {
    USER_LOGIN_SUCCESS,
    USER_LOGIN_FAIL_NETWORK,
    USER_LOGIN_FAIL_CREDENTIALS
} UserLoginStatus;

@property (nonatomic, retain) NSString *email;
@property (nonatomic, retain) NSString *pass;
@property (nonatomic, retain) NSString *user;
@property (nonatomic, retain) NSString *ident;
@property (nonatomic, assign) SEL selectorSuccess;
@property (nonatomic, assign) SEL selectorFailNetwork;
@property (nonatomic, assign) SEL selectorFailCredentials;
@property (nonatomic, assign) id target;

// singleton instance method
+ (User *)sharedUser;

// login using existing credentials (async)
-(void)login;

// login with specified credentials and save to keychain (async)
-(void)login:(NSString *)emailAddress password:(NSString *)password;

// logout and remove credentials from keychain (async)
-(void)logout;

// returns YES if credentials stored in keychain
-(BOOL)isValid;

@end
