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
    //keeps track of the first point touches were detected
    CGPoint beginning;
    //minimum distance dragged before recognized as a joystick event
    float min;
}
//temporary -- in future, SGEngine should have a view controller, not the other way round.
@property (retain) SGGameEngine* engine;

@end
