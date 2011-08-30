//
//  WebViewController.h
//  MyEyesAreHungry
//
//  Created by bobby on 7/28/11.
//  Copyright 2011 self. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface WebViewController : UIViewController <UIWebViewDelegate> {
    IBOutlet UIWebView *webView;
    NSString *urlString;
    UIActivityIndicatorView *spinner;
}

@property (nonatomic, retain) NSString *urlString;
@property (nonatomic, retain) IBOutlet UIWebView *webView;

@end
