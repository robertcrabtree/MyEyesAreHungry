//
//  UploadArrays.m
//  MyEyesAreHungry
//
//  Created by bobby on 8/10/11.
//  Copyright 2011 self. All rights reserved.
//

#import "UploadArrays.h"
#import "TBXML.h"


@implementation UploadArrays
@synthesize placeholders, postKeys, countryVals, stateVals, mealTypeVals, mealPriceUsaVals, mealPriceWorldVals, mealTasteVals, countryText, stateText, mealTypeText, mealPriceUsaText, mealPriceWorldText, mealTasteText;

-(void) allocArrays
{
    placeholders = [[NSArray alloc] initWithObjects:@"Restaurant Name", @"Restaurant Country", 
                    @"Restaurant City", @"Restaurant State", @"Meal Type", @"Meal Name", @"Meal Price", @"Meal Taste", nil];
    
    postKeys = [[NSArray alloc] initWithObjects:@"rest_name", @"country", @"city", @"state",
                @"dish_type", @"dish_name", @"dish_price_usa", @"dish_rating", nil];
    
    countryVals = [[NSMutableArray alloc] init];
    stateVals = [[NSMutableArray alloc] init];
    mealPriceUsaVals = [[NSMutableArray alloc] init];
    mealPriceWorldVals = [[NSMutableArray alloc] init];
    mealTypeVals = [[NSMutableArray alloc] init];
    mealTasteVals = [[NSMutableArray alloc] initWithObjects:@"1", @"2", @"3", @"4", nil];
    
    countryText = [[NSMutableArray alloc] init];
    stateText = [[NSMutableArray alloc] init];
    mealPriceUsaText = [[NSMutableArray alloc] init];
    mealPriceWorldText = [[NSMutableArray alloc] init];
    mealTypeText = [[NSMutableArray alloc] init];
    mealTasteText = [[NSMutableArray alloc] initWithObjects:@"Average", @"Good", @"Great", @"Amazing", nil];
}

-(id)init
{
    self = [super init];
    if (self) {
        
        // download xml file
        TBXML *tbxml = [[TBXML tbxmlWithURL:[NSURL URLWithString:@"http://www.myeyesarehungry.com/api/list.xml"]] retain];
        
        if (tbxml && tbxml.rootXMLElement) {
            
            TBXMLElement *category = tbxml.rootXMLElement->firstChild;
            
            [self allocArrays];

            do {
                TBXMLElement *valText1 = category->firstChild;
                TBXMLElement *valText2 = valText1->nextSibling;
                NSString *categoryName = [[TBXML elementName:category] lowercaseString];
                NSString *valTextStr1 = [TBXML elementName:valText1];
                NSString *text;
                NSString *val;
                
                // can't count on the order of "TITLE" or "VALUE"
                if ([[valTextStr1 lowercaseString] isEqualToString:@"title"]) {
                    text = [TBXML textForElement:valText1];
                    val = [TBXML textForElement:valText2];
                } else {
                    text = [TBXML textForElement:valText2];
                    val = [TBXML textForElement:valText1];
                }
                
                if ([categoryName isEqualToString:@"country"]) {
                    // restaurant country
                    [countryText addObject:text];
                    [countryVals addObject:val];
                } else if ([categoryName isEqualToString:@"state"]) {
                    // us state
                    [stateText addObject:text];
                    [stateVals addObject:val];
                } else if ([categoryName isEqualToString:@"currency_usa"]) {
                    // meal price (us currency)
                    [mealPriceUsaText addObject:text];
                    [mealPriceUsaVals addObject:val];
                } else if ([categoryName isEqualToString:@"currency"]) {
                    // meal price (non-us currency)
                    [mealPriceWorldText addObject:text];
                    [mealPriceWorldVals addObject:val];
                } else if ([categoryName isEqualToString:@"type"]) {
                    // meal type
                    [mealTypeText addObject:text];
                    [mealTypeVals addObject:val];
                } else if ([categoryName isEqualToString:@"taste"]) {
                    // meal taste
                    /// @todo waiting for neil to populate the xml file with this data
                    //[mealTasteText addObject:text];
                    //[mealTasteVals addObject:vals];
                }
            } while ((category = category->nextSibling));
        } else {
            NSLog(@"ERR: xml download error");
            self = nil;
        }
        
        [tbxml release];
    }
    return self;
}

- (void)dealloc
{
    [placeholders release];
    [postKeys release];
    [countryVals release];
    [stateVals release];
    [mealPriceUsaVals release];
    [mealPriceWorldVals release];
    [mealTypeVals release];
    [mealTasteVals release];
    [countryText release];
    [stateText release];
    [mealPriceUsaText release];
    [mealPriceWorldText release];
    [mealTypeText release];
    [mealTasteText release];
    [super dealloc];
}


@end
