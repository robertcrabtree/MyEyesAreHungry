//
//  UploadArrays.h
//  MyEyesAreHungry
//
//  Created by bobby on 8/10/11.
//  Copyright 2011 self. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UploadArrays : NSObject {
    // restaurant and meal textfield placeholders
    NSArray *placeholders;
        
    // HTTP POST keys
    NSMutableArray *postKeys;

    // HTTP POST values (lists only)
    NSMutableArray *countryVals;
    NSMutableArray *stateVals;
    NSMutableArray *mealTypeVals;
    NSMutableArray *mealPriceUsaVals;
    NSMutableArray *mealPriceWorldVals;
    NSMutableArray *mealTasteVals;
    
    // Display text (lists/pickers only)
    NSMutableArray *countryText;
    NSMutableArray *stateText;
    NSMutableArray *mealTypeText;
    NSMutableArray *mealPriceUsaText;
    NSMutableArray *mealPriceWorldText;
    NSMutableArray *mealTasteText;
}

// restaurant and meal textfield placeholders
@property (nonatomic, readonly) NSArray *placeholders;

// HTTP POST keys
@property (nonatomic, readonly) NSMutableArray *postKeys;

// HTTP POST values (lists only)
@property (nonatomic, readonly) NSMutableArray *countryVals;
@property (nonatomic, readonly) NSMutableArray *stateVals;
@property (nonatomic, readonly) NSMutableArray *mealTypeVals;
@property (nonatomic, readonly) NSMutableArray *mealPriceUsaVals;
@property (nonatomic, readonly) NSMutableArray *mealPriceWorldVals;
@property (nonatomic, readonly) NSMutableArray *mealTasteVals;

// Display text (lists/pickers only)
@property (nonatomic, readonly) NSMutableArray *countryText;
@property (nonatomic, readonly) NSMutableArray *stateText;
@property (nonatomic, readonly) NSMutableArray *mealTypeText;
@property (nonatomic, readonly) NSMutableArray *mealPriceUsaText;
@property (nonatomic, readonly) NSMutableArray *mealPriceWorldText;
@property (nonatomic, readonly) NSMutableArray *mealTasteText;

-(id) init;
- (void)dealloc;

@end
