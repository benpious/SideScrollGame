//
//  SGWalkAgent.m
//  SideScrollGame
//
//  Created by Benjamin Pious on 2/28/13.
//  Copyright (c) 2013 Benjamin Pious. All rights reserved.
//

#import "SGWalkAgent.h"

@implementation SGWalkAgent
@synthesize actions;
//never respond to any requests if by some chance they are made, just keep moving forwards
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
    [self.character setNextAnimation:forwards];
    return forwards;
    
}

@end
