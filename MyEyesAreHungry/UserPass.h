//
//  UserPass.h
//  MyEyesAreHungry
//
//  Created by bobby on 8/3/11.
//  Copyright 2011 self. All rights reserved.
//

#import <Foundation/Foundation.h>

// to be used as a singleton only
@interface UserPass : NSObject {
    NSString *username;
    NSString *password;
}

+ (UserPass *)sharedUserPass; // singleton instance method
- (BOOL)isValid;
- (BOOL)setUser:(NSString *)username Pass:(NSString *)password;

@property (readonly) NSString *username;
@property (readonly) NSString *password;

@end
