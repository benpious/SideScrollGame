//
//  SGAbstractAgent.m
//  SideScrollGame
//
//  Created by Benjamin Pious on 2/28/13.
//  Copyright (c) 2013 Benjamin Pious. All rights reserved.
//

#import "SGAbstractAgent.h"

@implementation SGAbstractAgent
@synthesize actions;
@synthesize character;
-(id)initWithCharacter:(SGCharacter *)character
{
    if (self = [super init]) {
        self.character = character;
    }
    
    return self;
}
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
