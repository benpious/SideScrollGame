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
    int start;
    int end;
} animationDuration;

enum {
    attackAction, forwardAction, backwardsAction, jumpAction, crouchAction

} action;

@interface SGCharacter : NSObject<SGEntityProtocol>
@property (assign) int health;
@property (retain) NSMutableArray* animations;
@property (retain) GLKTextureInfo *texture;

-(void) loadTexture: (NSString*) imageName;

//all files that the character will need to load to initialize will have the same name + a suffix indicating what they do
-(id) initCharacterNamed: (NSString*) name;

@end
