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

+(levelPath*) breadthFirstSearchWithHead: (levelNode*) head Goal: (id) goal
{
    levelPath* pathHead = malloc(sizeof(pathHead));
    levelNode* curr = head;
    
    for (int i =0; i<curr->numLeaves; i++) {
        if (curr->leaves[i]->nextNode->data == goal) {
            ;
        }
        else
        {
            ;
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
