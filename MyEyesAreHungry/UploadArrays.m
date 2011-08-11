//
//  UploadArrays.m
//  MyEyesAreHungry
//
//  Created by bobby on 8/10/11.
//  Copyright 2011 self. All rights reserved.
//

#import "UploadArrays.h"




@implementation UploadArrays
@synthesize mealPlaceholders, restPlaceholders, postKeys, countryVals, stateVals, mealTypeVals, mealPriceVals, mealTasteVals, countryText, stateText, mealTypeText, mealPriceText, mealTasteText;

-(id)init
{
    self = [super init];
    if (self) {
        
        restPlaceholders = [[NSArray alloc] initWithObjects:@"Restaurant Name", @"Restaurant Country", 
                            @"Restaurant City", @"Restaurant State", nil];
        
        mealPlaceholders = [[NSArray alloc] initWithObjects:@"Meal Type", @"Meal Name", @"Meal Price", @"Meal Taste", nil];
        
        postKeys = [[NSArray alloc] initWithObjects:@"rest_name", @"country", @"city", @"state",
                    @"dish_type", @"dish_name", @"dish_price_usa", @"dish_rating", nil];
        
        countryVals = [[NSArray alloc] initWithObjects:@"usa", nil];
        
        stateVals = [[NSArray alloc] initWithObjects:@"CA", @"OH", @"ID", nil];
        
        mealPriceVals = [[NSArray alloc] initWithObjects:@"under $10", @"$10 - $14", @"$15 - $19", @"$20 - $29", @"$30 - $39", @"$over $39", nil];
        
        mealTypeVals = [[NSArray alloc] initWithObjects:@"bread_pastry", @"burger_hotdog", @"dessert", @"egg", @"fruit", @"grain_bean", @"meat", @"noodle_pasta", @"pizza_pie", @"sandwich_wrap", @"seafood_sushi", @"soup", @"vegetable_tofu", nil];
        
        mealTasteVals = [[NSArray alloc] initWithObjects:@"1", @"2", @"3", @"4", nil];
        
        countryText = [[NSArray alloc] initWithObjects:@"USA", nil];
        
        stateText = [[NSArray alloc] initWithObjects:@"California", @"Ohio", @"Idaho", nil];
        
        mealPriceText = [[NSArray alloc] initWithObjects:@"under $10", @"$10 - $14", @"$15 - $19", @"$20 - $29", @"$30 - $39", @"$over $39", nil];
        
        mealTypeText = [[NSArray alloc] initWithObjects:@"Bread / Pastry", @"Burger / Hotdog", @"Dessert", @"Egg", @"Fruit", @"Grain / Bean", @"Meat", @"Noodle / Pasta", @"Pizza / Pie", @"Sandwich / Wrap", @"Seafood / Sushi", @"Soup", @"Vegetable / Tofu", nil];
        
        mealTasteText = [[NSArray alloc] initWithObjects:@"Average", @"Good", @"Great", @"Amazing", nil];
    }
    return self;
}

- (void)dealloc
{
    [mealPlaceholders dealloc];
    [restPlaceholders dealloc];
    [postKeys dealloc];
    [countryVals dealloc];
    [stateVals dealloc];
    [mealPriceVals dealloc];
    [mealTypeVals dealloc];
    [mealTasteVals dealloc];
    [countryText dealloc];
    [stateText dealloc];
    [mealPriceText dealloc];
    [mealTypeText dealloc];
    [mealTasteText dealloc];
    [super dealloc];
}


@end
