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
#import "actions.h"
#import "SGGameEngine.h"

@interface SGViewController : GLKViewController
{
    CGPoint beginning;
    BOOL moving;
    action currAction;
    float min;
}

@property (retain) SGGameEngine* engine;

@end
