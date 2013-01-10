//
//  Playable.h
//  SideScrollGame
//
//  Created by Benjamin Pious on 1/9/13.
//  Copyright (c) 2013 Benjamin Pious. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "actions.h"

@protocol Playable <NSObject>
//specifies what methods and properties an object must implement to be playable by a human

//these methods implement the logic for receiving events from the engine
-(void) receiveJoystickInput: (action) direction;
-(void) receiveButtonInput: (char) button;

//returns an array specifying which inputs should be displayed and in what positions
-(NSArray*) inputsToDisplay;


@end
