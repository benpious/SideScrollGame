//
//  SGLevel.m
//  SideScrollGame
//
//  Created by Benjamin Pious on 1/4/13.
//  Copyright (c) 2013 Benjamin Pious. All rights reserved.
//

#import "SGLevel.h"

@implementation SGLevel
-(id) initWithLevelPlistNamed: (NSString*) levelName
{
    if (self = [super initObjectNamed:levelName]) {
        ;
    }
    
    return self;
}

-(void) loadLevelTextureDataNamed: (NSString*) levelName
{
    
}

-(void) loadNodeDataForLevelNamed: (NSString*) levelNodeData
{
    
}

+(levelNode*) depthFirstSearchWithHead: (levelNode*) head Goal: (id) goal
{
    levelNode* curr = head;
    if (curr->data == goal) {
        return curr;
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

-(void) populateArrays
{
    
    self.vertexCoords = malloc(sizeof(GLfloat) * 18);
    
    
    GLfloat proportion;
    
    if (self.width > self.height) {
        proportion = self.height/self.width;
        
        self.vertexCoords[0] = 1.0f;
        self.vertexCoords[1] = proportion;
        self.vertexCoords[3] = -1.0f;
        self.vertexCoords[4] = -1.0f;
        self.vertexCoords[6] = -1.0f;
        self.vertexCoords[7] = proportion;
        self.vertexCoords[9] = 1.0f;
        self.vertexCoords[10] = proportion;
        self.vertexCoords[12] = 1.0f;
        self.vertexCoords[13] = -1.0f;
        self.vertexCoords[15] = -1.0f;
        self.vertexCoords[16] = -1.0f;
    }
    
    else {
        
        
        proportion = self.width/self.height;
        self.vertexCoords[0] = proportion;
        self.vertexCoords[1] = 1.0f;
        self.vertexCoords[3] = -1.0f;
        self.vertexCoords[4] = -1.0f;
        self.vertexCoords[6] = -1.0f;
        self.vertexCoords[7] = 1.0f;
        self.vertexCoords[9] = proportion;
        self.vertexCoords[10] = 1.0f;
        self.vertexCoords[12] = proportion;
        self.vertexCoords[13] = -1.0f;
        self.vertexCoords[15] = -1.0f;
        self.vertexCoords[16] = -1.0f;
        
        
    }
    
    //fill the z coords with 0s
    for (int i = 0; i <= 5 ; i++) {
        self.vertexCoords[i*3+2] = 0.0f;
    }
    
}


@end
