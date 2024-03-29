//
//  SGEntity.h
//  SideScrollGame
//
//  Created by Benjamin Pious on 12/15/12.
//  Copyright (c) 2012 Benjamin Pious. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>
#import "SGEntityProtocol.h"
#import "actions.h"
#import "SGMassProtocol.h"

/*
 This class is for anything with an animation and movements.
*/

typedef struct {
    NSString* name;
    int duration;
    GLuint* coords;
    GLfloat xOffset;
    GLfloat yOffset;
    SGHitMask** animationHitmasks;
} animation;


@interface SGCharacter : NSObject<SGEntityProtocol, SGMassProtocol>
{
    //keeps track of the current frame in the animation
    int currentFrame;
    int currentAnimation;
    int numAnimations;
    
    //2d array of animations -- consider replacing with a dictionary of animation arrays
    animation** animations;
    
    GLfloat movementX;
    GLfloat movementY;
}

@property (assign) int health;
//all files that the character will need to load to initialize will have the same name + a suffix indicating what they do
// nametexture, nameinfo
-(id) initCharacterNamed: (NSString*) name withScreenSize: (CGRect) screenSize;
-(void)nextFrame;
-(void) undoAction;
-(GLfloat*) glFloatArrayFromOriginX: (GLfloat) x OriginY: (GLfloat) y;
-(void) setNextAnimation: (int) animation;

@end
