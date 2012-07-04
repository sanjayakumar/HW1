//
//  CalculatorBrain.m
//  Calculator
//
//  Created by Sanjaya Kumar on 7/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CalculatorBrain.h"

@interface CalculatorBrain()
@property (nonatomic, strong) NSMutableArray *operandStack;
@end

@implementation CalculatorBrain

@synthesize operandStack = _operandStack;

- (NSMutableArray *)operandStack
{
    if (!_operandStack) {
        _operandStack = [ [NSMutableArray alloc] init];
    }
    return _operandStack;
}


- (void) pushOperand:(double)operand
{
    NSNumber *operandObject = [NSNumber numberWithDouble:operand];
    [self.operandStack addObject:operandObject];
    
}

- (double)popOperand
{
    NSNumber *operandObject = [self.operandStack lastObject];
    if (operandObject) [self.operandStack removeLastObject];
    return [operandObject doubleValue];
}

- (void)performClear
{        
    [self.operandStack removeAllObjects];
}

- (double)performOperation:(NSString *)operation
{
    double result = 0;
    
    if ([operation isEqualToString:@"+"]) {
        result = [self popOperand] + [self popOperand];
    } else if ([@"*" isEqualToString:operation]) {
        result = [self popOperand] * [self popOperand];
    } else if ([operation isEqualToString:@"-"]) {
        double subtraend = [self popOperand];
        result = [self  popOperand] - subtraend;
    } else if ([operation isEqualToString:@"/"]){
        double divisor = [self popOperand];
        if (divisor) result = [self popOperand] / divisor;
    } else if ([operation isEqualToString:@"π"]){
        result = M_PI;
    } else if ([operation isEqualToString:@"sin"]){
        double angle = [self popOperand];
        angle = angle/360.0*2*M_PI;
        result = sin(angle);
    } else if ([operation isEqualToString:@"cos"]){
        double angle = [self popOperand];
        angle = angle/360.0*2*M_PI;
        result = cos(angle);
    } else if ([operation isEqualToString:@"sqrt"]){
        double val = [self popOperand];
        result = pow(val, 0.5);
    }
    
    [self pushOperand:result];
    
    return result;
}

@end
