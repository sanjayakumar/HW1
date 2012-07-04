//
//  CalculatorViewController.m
//  Calculator
//
//  Created by Sanjaya Kumar on 7/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CalculatorViewController.h"
#import "CalculatorBrain.h"

@interface CalculatorViewController()
@property (nonatomic) BOOL userIsInTheMiddleOfEnteringANumber;
@property (nonatomic, strong) CalculatorBrain *brain;
@end

@implementation CalculatorViewController
@synthesize display = _display;
@synthesize userActionDisplay = _userActionDisplay;
@synthesize userIsInTheMiddleOfEnteringANumber = _userIsInTheMiddleOfEnteringANumber;
@synthesize brain = _brain;

- (CalculatorBrain *)brain
{
    if (!_brain) _brain = [[CalculatorBrain alloc] init];
    return _brain;
}

- (void) updateUserActionDisplay: (NSString *)dispString {
    NSString *userDispText = [self.userActionDisplay.text stringByAppendingString:dispString];
    NSUInteger userActionDisplayLength = [userDispText length];
    
    if (userActionDisplayLength >= MAX_USER_ACTION_DISPLAY_LENGTH){
        userDispText = [userDispText substringWithRange:NSMakeRange(userActionDisplayLength - MAX_USER_ACTION_DISPLAY_LENGTH - 1, MAX_USER_ACTION_DISPLAY_LENGTH)];
    }
    self.userActionDisplay.text = userDispText;
}

- (IBAction)digitPressed:(UIButton *)sender {
    NSString *digit = sender.currentTitle;
    if (self.userIsInTheMiddleOfEnteringANumber) {
        self.display.text = [self.display.text stringByAppendingString:digit];
    } else {
        self.display.text = digit;
        /* If the user presses 0 in the begining, we simply ignore it, i.e. act like the user hasn't started to type a number */
        if ([digit isEqualToString:@"0"]){
            return;
        }
        self.userIsInTheMiddleOfEnteringANumber = YES;
    }
}

- (IBAction)enterPressed {
    [self.brain pushOperand:[self.display.text doubleValue]];
    self.userIsInTheMiddleOfEnteringANumber = NO;
    
    [self updateUserActionDisplay:[NSString stringWithFormat:@" %@ ", self.display.text]];
}

- (IBAction)operationPressed:(id)sender {
    NSString *operation = [sender currentTitle];
    // invalid action protection (a) divide by zero and (b) sqrt of negative number
    // not entirely sure if this is the right place to do it.
    if ([operation isEqualToString:@"sqrt"] && [self.display.text hasPrefix:@"-"]){
        self.userActionDisplay.text = @"Cannot do Square Root of negative number";
        self.userIsInTheMiddleOfEnteringANumber = NO;
        return;
    }
    if ([operation isEqualToString:@"/"] && [self.display.text isEqualToString:@"0"]){
        self.userActionDisplay.text = @"Cannot divide by zero";
        self.userIsInTheMiddleOfEnteringANumber = NO;
        return;
    }
    
    if (self.userIsInTheMiddleOfEnteringANumber) {
        [self enterPressed];
    }
    double result = [self.brain performOperation:operation];
    self.display.text = [NSString stringWithFormat:@"%g", result];
    
    [self updateUserActionDisplay:[NSString stringWithFormat:@" %@ = ", operation]];
}

- (IBAction)decimalKeyPressed {
    if (!self.userIsInTheMiddleOfEnteringANumber){
        self.display.text = @"0.";
        self.userIsInTheMiddleOfEnteringANumber = YES;
    } else {
        NSRange isDecimalPresent = [self.display.text rangeOfString:@"."];
        if (isDecimalPresent.location == NSNotFound){
            self.display.text = [self.display.text stringByAppendingString:@"."];
        } // ignore the user-pressed decimal if it is already present
    }        
}

- (IBAction)clearPressed {
    self.display.text = @"0";
    self.userActionDisplay.text = @"";
    [self.brain performClear];
}

- (IBAction)backspacePressed {
    NSUInteger existingStringLength = [self.display.text length];
    // Only numbers that are not already in the stack are modifiable
    if (self.userIsInTheMiddleOfEnteringANumber){
        if (existingStringLength == 1) { 
            self.display.text = @"0";
        } else {
            self.display.text = [self.display.text substringToIndex:existingStringLength-1];
        }
    }
}
- (void)viewDidUnload {
    [self setUserActionDisplay:nil];
    [super viewDidUnload];
}
- (IBAction)plusMinusPressed:(UIButton *)sender {
    if([self.display.text isEqualToString:@"0"]){
        // like the OS X calculator, ignore +/- if only zero is displayed.
        return;
    }
    if (self.userIsInTheMiddleOfEnteringANumber){
        if ([self.display.text hasPrefix:@"-"]){
            self.display.text = [self.display.text stringByReplacingOccurrencesOfString:@"-" withString:@""];
        } else {
            self.display.text =  [NSString stringWithFormat:@"-%@", self.display.text];
        }
    } else {
        // this is something funky. Multiply the number in the top of the stack by -1
        [self.brain pushOperand: -1];
        double result = [self.brain performOperation:@"*"];
        self.display.text = [NSString stringWithFormat:@"%g", result];
        
        [self updateUserActionDisplay:[NSString stringWithFormat:@" +/- = ", self.display.text]];
    }
}
@end