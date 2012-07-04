//
//  CalculatorViewController.h
//  Calculator
//
//  Created by Sanjaya Kumar on 7/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CalculatorViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *display;
@property (weak, nonatomic) IBOutlet UILabel *userActionDisplay;
- (void) updateUserActionDisplay: (NSString *)dispString;
@end

#define MAX_USER_ACTION_DISPLAY_LENGTH 40 // max number of characters in the top strip of the calculator
