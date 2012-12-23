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

/*
 This class is for anything with an animation
 
*/

typedef struct {
    NSString* name;
    int duration;
    GLfloat** coords;
    GLfloat xOffset;
    GLfloat yOffset;
} animation;


@interface SGCharacter : NSObject<SGEntityProtocol>
{
    //keeps track of the current frame in the animation
    int currentFrame;
    int currentAnimation;
    int numAnimations;
    
    //2d array of animations -- consider replacing with a dictionary of animation arrays
    animation** animations;
    
    GLfloat width;
    GLfloat height;
}

@property (assign) int health;
//all files that the character will need to load to initialize will have the same name + a suffix indicating what they do
// nametexture, nameinfo
-(id) initCharacterNamed: (NSString*) name;
-(void)nextFrame;

@end
