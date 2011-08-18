//
//  Login.h
//  MyEyesAreHungry
//
//  Created by bobby on 8/7/11.
//  Copyright 2011 self. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Login : NSObject {
    
}

+(NSString *) loginWithUsername:(NSString *) username andPassword:(NSString *) password;
+(void) logout;
+(NSString *) userToken;

@end
