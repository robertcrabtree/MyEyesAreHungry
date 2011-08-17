//
//  UploadArrays.h
//  MyEyesAreHungry
//
//  Created by bobby on 8/10/11.
//  Copyright 2011 self. All rights reserved.
//

#import <Foundation/Foundation.h>

/// @todo need to support non-us countries and currency

@interface UploadArrays : NSObject {
    // restaurant and meal textfield placeholders
    NSArray *placeholders;
        
    // HTTP POST keys
    NSArray *postKeys;

    // HTTP POST values (lists only)
    NSArray *countryVals;
    NSArray *stateVals;
    NSArray *mealTypeVals;
    NSArray *mealPriceVals;
    NSArray *mealTasteVals;
    
    // Display text (lists/pickers only)
    NSArray *countryText;
    NSArray *stateText;
    NSArray *mealTypeText;
    NSArray *mealPriceText;
    NSArray *mealTasteText;
}

// restaurant and meal textfield placeholders
@property (nonatomic, readonly) NSArray *placeholders;

// HTTP POST keys
@property (nonatomic, readonly) NSArray *postKeys;

// HTTP POST values (lists only)
@property (nonatomic, readonly) NSArray *countryVals;
@property (nonatomic, readonly) NSArray *stateVals;
@property (nonatomic, readonly) NSArray *mealTypeVals;
@property (nonatomic, readonly) NSArray *mealPriceVals;
@property (nonatomic, readonly) NSArray *mealTasteVals;

// Display text (lists/pickers only)
@property (nonatomic, readonly) NSArray *countryText;
@property (nonatomic, readonly) NSArray *stateText;
@property (nonatomic, readonly) NSArray *mealTypeText;
@property (nonatomic, readonly) NSArray *mealPriceText;
@property (nonatomic, readonly) NSArray *mealTasteText;

-(id) init;
- (void)dealloc;

@end
