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
    // meal textfield placeholders
    NSArray *mealPlaceholders;
    
    // restaurant textfield placeholders
    NSArray *restPlaceholders;
    
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

// meal textfield placeholders
@property (nonatomic, retain, readonly) NSArray *mealPlaceholders;

// restaurant textfield placeholders
@property (nonatomic, retain, readonly) NSArray *restPlaceholders;

// HTTP POST keys
@property (nonatomic, retain, readonly) NSArray *postKeys;

// HTTP POST values (lists only)
@property (nonatomic, retain, readonly) NSArray *countryVals;
@property (nonatomic, retain, readonly) NSArray *stateVals;
@property (nonatomic, retain, readonly) NSArray *mealTypeVals;
@property (nonatomic, retain, readonly) NSArray *mealPriceVals;
@property (nonatomic, retain, readonly) NSArray *mealTasteVals;

// Display text (lists/pickers only)
@property (nonatomic, retain, readonly) NSArray *countryText;
@property (nonatomic, retain, readonly) NSArray *stateText;
@property (nonatomic, retain, readonly) NSArray *mealTypeText;
@property (nonatomic, retain, readonly) NSArray *mealPriceText;
@property (nonatomic, retain, readonly) NSArray *mealTasteText;

-(id) init;
- (void)dealloc;

@end
