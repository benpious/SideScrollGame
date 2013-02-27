//
//  SGAction.m
//  SideScrollGame
//
//  Created by Benjamin Pious on 12/20/12.
//  Copyright (c) 2012 Benjamin Pious. All rights reserved.
//

#import "SGAction.h"

@implementation SGAction
@synthesize hitmask;
@synthesize position;

-(id) initWithArea: (CGRect const) area Damage: (int const) damage knockBack: (GLfloat const) knockBack forceNextAnimation: (BOOL const) forceNextAnimation nextAction: (NSString*) nextAction
{
    if (self = [super init]) {
        self.position = malloc(sizeof(CGRect));
        *self.position = area;
        self.damage = damage;
        self.knockBack = knockBack;
        self.forceNextAnimation = forceNextAnimation;
        self.nextAction = nextAction;
    }
    
    return self;
}

-(void) dealloc
{
    for (int i =0; i<self.numFramesActive; i++) {
        [self.actionMasks[i] release];
    }
    
    free(self.position);
    [super dealloc];
}

@end
