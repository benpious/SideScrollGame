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
#import "SGMassProtocol.h"
#import "LevelNavStructs.h"
#import "SGWalkAgent.h"

/*
 Contains methods releated to game logic and loading individual levels. Each time a new level is needed create a new
 SGGAmeEngine with the initwithlevelplist method. 
 */
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
@property (assign) SGCharacter<Playable,SGMassProtocol, SGEntityProtocol>* player;
@property (assign) GLfloat cameraYOffset;
@property (assign) GLfloat cameraXOffset;
@property (retain) SGLevel* level;
@property (assign) CGRect viewFrame;

-(id) initWithLevelPlist: (NSString*) levelName ScreenSize: (CGRect) screenSize;
//if the viewcontroller has recognized a joystick action, this method is called
-(void) applyJoystickMovewithAngle: (GLfloat) angle XPos: (GLfloat) xPos YPos: (GLfloat) yPos Radians: (GLfloat) radiansAngle Size: (CGSize) size;
//if the viewcontroller recognizes a button press, this method is called
-(void) applyTouchDownWithLocation:(CGPoint) loc;
-(void) applyTouchUpWithLocation: (CGPoint) loc;
//returns an array of objects conforming to SGEntityProtocol, used by the view controller for drawing
-(NSMutableArray*) objectsToDraw;
//main game loop
-(void) eventLoopCallBack;

-(BOOL)hitDetectedBetween: (NSObject<SGMassProtocol> const * const) a and: (NSObject<SGMassProtocol>const * const) b;

@end
