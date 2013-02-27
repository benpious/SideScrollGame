//
//  SGMainCharacter.m
//  SideScrollGame
//
//  Created by Benjamin Pious on 1/9/13.
//  Copyright (c) 2013 Benjamin Pious. All rights reserved.
//


#import "SGMainCharacter.h"


@implementation SGMainCharacter
@synthesize inputsToDisplay;
-(void) receiveJoystickInput: (action) direction
{
    switch (direction) {
        case up:
            currentAnimation = 3;
            break;
        case down:
            currentAnimation = 4;
            break;
        case forwards:
            currentAnimation = 2;
            break;
        case backwards:
            currentAnimation = forwards;
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

@end
