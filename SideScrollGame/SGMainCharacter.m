//
//  SGMainCharacter.m
//  SideScrollGame
//
//  Created by Benjamin Pious on 1/9/13.
//  Copyright (c) 2013 Benjamin Pious. All rights reserved.
//


const int idleAnimation = 0;
const int walkForwardAnimation = 1;
const int attackAnimation = 2;
const int blockAnimation = 3;
#import "SGMainCharacter.h"


@implementation SGMainCharacter

-(void) receiveJoystickInput: (action) direction
{
    switch (direction) {
        case up:
            currentAnimation = walkForwardAnimation;
            break;
        case down:
            currentAnimation = walkForwardAnimation;
            break;
        case forwards:
            currentAnimation = walkForwardAnimation;
            break;
        case backwards:
            currentAnimation = walkForwardAnimation;
            break;
        default:
            break;
    }
}

-(void) receiveButtonInput: (char) button
{
    if (button == 'a') {
        ;
    }
    
    if (button == 'b') {
        ;
    }
}

//returns an array specifying which inputs should be displayed and in what positions
-(NSArray*) inputsToDisplay
{
    
}

@end
