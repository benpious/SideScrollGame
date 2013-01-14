//
//  SGGameEngine.h
//  SideScrollGame
//
//  Created by Benjamin Pious on 12/15/12.
//  Copyright (c) 2012 Benjamin Pious. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SGCharacter.h"
#import "SGQueue.h"
#import "SGAction.h"
#import "SGAgentProtocol.h"
#import "SGObjectEntity.h"
#import "actions.h"
#import "Playable.h"
#import "SGMainCharacter.h"
#import "SGJoystick.h"
#import "SGLevel.h"

@interface SGGameEngine : NSObject
{
    SGQueue* actionQueue;
    NSTimer* renderTimer;
    GLfloat gravitySpeed;
    action joystickDirection;
    SGJoystick* joystick;

}

@property (retain) NSMutableArray* objects;
@property (retain) NSMutableArray* characters;
@property (assign) SGCharacter<Playable>* player;
@property (assign) GLfloat cameraYOffset;
@property (assign) GLfloat cameraXOffset;
@property (retain) SGLevel* level;

-(id) initWithLevelPlist: (NSString*) levelName;

//if the viewcontroller has recognized a joystick action, this method is called
-(void) applyJoystickMovewithAngle: (GLfloat) angle XPos: (GLfloat) xPos YPos: (GLfloat) yPos Radians: (GLfloat) radiansAngle Size: (CGSize) size;
//if the viewcontroller recognizes a button press, this method is called
-(void) applyTouchDownWithLocation:(CGPoint) loc;
-(void) applyTouchUpWithLocation: (CGPoint) loc;

-(NSMutableArray*) objectsToDraw;
-(void) eventLoopCallBack;
@end
