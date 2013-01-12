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
@synthesize effect;
@synthesize vertexCoords;
@synthesize textureCoords;
@synthesize texture;
@synthesize fallSpeed;
@synthesize isFalling;
@synthesize hitmask;
@synthesize height;
@synthesize width;

-(id) initJoystick
{
    if (self = [super initObjectNamed:@"joystick"]) {
        shouldDraw = NO;
    }
    return  self;
}

-(void) recieveJoystickInputWithAngle:(GLfloat)angle XPos:(GLfloat)xPos YPos:(GLfloat)yPos
{
    effect.transform.projectionMatrix = GLKMatrix4Multiply(GLKMatrix4MakeTranslation(xPos, yPos, 0), GLKMatrix4MakeRotation(angle, 0, 0, 1));

    shouldDraw = YES;
}

-(void) joyStickInputStopped
{
    shouldDraw = NO;
}
@end
