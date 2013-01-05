//
//  SGViewController.h
//  SideScrollGame
//
//  Created by Benjamin Pious on 11/5/12.
//  Copyright (c) 2012 Benjamin Pious. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GLKit/GLKit.h>

#import "SGObjectEntity.h"
#import "SGCharacter.h"
#import "actions.c"
#import "SGGameEngine.h"

@interface SGViewController : GLKViewController
{
    CGPoint beginning;
    BOOL forward;
    BOOL backward;
    BOOL up;
    BOOL down;
    BOOL moving;
    float movementX;
    float movementY;
    float min;
    SGCharacter* object;
}

@property (retain) SGGameEngine* engine;

@end
