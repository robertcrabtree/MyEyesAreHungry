//
//  TouchTableView.h
//  MyEyesAreHungry
//
//  Created by bobby on 8/21/11.
//  Copyright 2011 self. All rights reserved.
//

#import <Foundation/Foundation.h>


// class to override touchesEnded so we can hide keyboard for any textfields that are the first responder
@interface TouchTableView : UITableView {
    
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event;

@end
