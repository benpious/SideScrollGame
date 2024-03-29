//
//  SGStaticAgent.m
//  SideScrollGame
//
//  Created by Benjamin Pious on 1/5/13.
//  Copyright (c) 2013 Benjamin Pious. All rights reserved.
//

#import "SGStaticAgent.h"

@implementation SGStaticAgent
@synthesize actions;

//never respond to any requests if by some chance they are made
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
    
    return idle;
}

@end
