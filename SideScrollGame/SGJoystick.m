//
//  SGJoystick.m
//  SideScrollGame
//
//  Created by Benjamin Pious on 1/10/13.
//  Copyright (c) 2013 Benjamin Pious. All rights reserved.
//

#import "SGJoystick.h"

@implementation SGJoystick
@synthesize shouldDraw;


-(id) initJoystickWithScreenSize:(CGRect) screenSize
{
    if (self = [super initObjectNamed:@"joystick" withScreenSize: screenSize]) {
        shouldDraw = NO;
    }
    return  self;
}

-(void) recieveJoystickInputWithAngle:(const GLfloat)angle XPos:(const GLfloat)xPos YPos:(const GLfloat)yPos
{
    self.effect.transform.projectionMatrix = GLKMatrix4Scale(GLKMatrix4Multiply(GLKMatrix4MakeTranslation(xPos, yPos, 0), GLKMatrix4MakeRotation(angle, 0, 0, 1)), 0.25f, 0.25f, 0.0f);

    shouldDraw = YES;
}

-(void) joyStickInputStopped
{
    shouldDraw = NO;
}
@end
