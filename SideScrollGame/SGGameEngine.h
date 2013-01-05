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

@interface SGGameEngine : NSObject
{
    SGQueue* actionQueue;
    NSTimer* renderTimer;
    GLfloat gravitySpeed;

}

@property (retain) NSMutableArray* objects;
@property (retain) NSMutableArray* characters;
@property (assign) SGCharacter* player;
@property (assign) GLfloat cameraYOffset;
@property (assign) GLfloat cameraXOffset;

-(id) initWithLevelPlist: (NSString*) levelName;

//if the viewcontroller has recognized a joystick action, this method is called
-(void) applyJoystickMovewithAngle: (GLfloat) angle;
//if the viewcontroller recognizes a button press, this method is called
-(void) applyTouchDownWithLocation:(CGPoint) loc;
-(void) applyTouchUpWithLocation: (CGPoint) loc;

-(NSMutableArray*) objectsToDraw;
-(void) eventLoopCallBack;
@end
