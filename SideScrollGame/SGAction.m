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
        _area = area;
        _damage = damage;
        _knockBack = knockBack;
        _forceNextAnimation = forceNextAnimation;
        _nextAction = nextAction;
    }
    
    return self;
}

@end
