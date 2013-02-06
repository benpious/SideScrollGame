//
//  SGJoystick.h
//  SideScrollGame
//
//  Created by Benjamin Pious on 1/10/13.
//  Copyright (c) 2013 Benjamin Pious. All rights reserved.
//

#import "SGObjectEntity.h"
#import "SGEntityProtocol.h"
@interface SGJoystick : SGObjectEntity<SGEntityProtocol>

@property (assign) BOOL shouldDraw;
-(void) recieveJoystickInputWithAngle:(const GLfloat) angle XPos: (const GLfloat) xPos YPos: (const GLfloat) yPos;
-(id) initJoystick;
-(void) joyStickInputStopped;

@end
