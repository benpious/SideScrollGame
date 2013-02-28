//
//  SGLevel.m
//  SideScrollGame
//
//  Created by Benjamin Pious on 1/4/13.
//  Copyright (c) 2013 Benjamin Pious. All rights reserved.
//

#import "SGLevel.h"

@implementation SGLevel
-(id) initWithLevelPlistNamed: (NSString*) levelName withScreenSize: (CGRect) screenSize
{
    //eventually will need some stuff here
    if (self = [super initObjectNamed:levelName withScreenSize:screenSize]) {
        
        ;
    }
    
    return self;
}

/*
 Since OpenGL ES caps the size of a texture at ~2048x2048, we may need to load in several textures
 Furthermore, it may be that it is better to "bake" lighting rather than calculating it for every pixel of the background,
 since this is likely a major factor in the current frame rate issues on the simulator (current as of 2/27/13)
 this should probably override the sgobject method, but until it is implemented I'll keep the current name (fucking awful, I know)
 */
-(void) loadLevelTextureDataNamed: (NSString*) levelName
{
    
}

-(void) loadNodeDataForLevelNamed: (NSString*) levelNodeData
{
    
}

+(levelPath*) dijkstra: (levelNode*) head Goal: (int) goalID
{
    levelPath* pathHead = malloc(sizeof(pathHead));
    SGQueue* queue = [[SGQueue alloc] init];
    [queue offer:head];
    
    while (queue.length > 0) {
        levelNode* curr = [queue pop];
        for (int i =0; i<curr->numLeaves; i++) {
            if (curr->leaves[i]->nextNode->identifier == goalID) {
                break;
            }
            else
            {
                [queue offer:curr] ;
            }
        }
        if (curr->identifier == goalID) {
            break;
        }

    }
    
}

-(BOOL) shouldSwitchLevel: (GLfloat) xPos
{
    if (xPos > changePoint) {
        [self switchLevel];
        return YES;
    }
    
    return NO;
}

-(void) switchLevel
{
    
}

-(void) dealloc
{
    [super dealloc];
    
}



@end
