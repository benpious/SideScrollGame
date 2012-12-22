//
//  SGAction.m
//  SideScrollGame
//
//  Created by Benjamin Pious on 12/20/12.
//  Copyright (c) 2012 Benjamin Pious. All rights reserved.
//

#import "SGAction.h"

@implementation SGAction

-(id) initWithArea: (CGRect) area Damage: (float) damage knockBack: (float) knockBack forceNextAnimation: (BOOL) forceNextAnimation nextAction: (NSString* ) nextAction
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
