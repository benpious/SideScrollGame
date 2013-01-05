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

-(id) init
{
    if (self = [super init]) {
        noAction = [[SGAction alloc] initWithArea: CGRectMake(0, 0, 0, 0)  Damage:0.0f knockBack:0.0f forceNextAnimation:NO nextAction:nil];
    }
    
    return self;
}

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

-(SGAction*) requestMoveWithGameState: (NSArray*) gameState
{
    return noAction;
}

@end
