//
//  SGSimpleAttackAgent.m
//  SideScrollGame
//
//  Created by Benjamin Pious on 1/5/13.
//  Copyright (c) 2013 Benjamin Pious. All rights reserved.
//

#import "SGSimpleAttackAgent.h"

@implementation SGSimpleAttackAgent
@synthesize actions;
//never respond to any requests if by some chance they are made, attack at all costs
-(BOOL) flankOrder
{
    return NO;
}
-(BOOL) attackOrder
{
    return NO;
}

-(BOOL) waitOrder
{
    return NO;
}

-(action) requestMoveWithGameState: (NSArray*) gameState
{
    //if within attack range attack
    
    //if not get the next node to be there
    
    
    //determine the next action to take
    
    
}

@end
