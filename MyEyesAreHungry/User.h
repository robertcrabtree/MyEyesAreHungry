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
    SEL selectorSuccess;
    SEL selectorFailNetwork;
    SEL selectorFailCredentials;
    id target;
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

// login using existing credentials (synchronous helper method)
-(UserLoginStatus)login;

// login with specified credentials and save to keychain
-(UserLoginStatus)login:(NSString *)emailAddress password:(NSString *)password async:(BOOL)async;

// logout and remove credentials from keychain
-(void)logout;

// returns YES if credentials stored in keychain
-(BOOL)isValid;

@end
