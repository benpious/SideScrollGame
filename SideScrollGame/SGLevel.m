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
    if (self = [super initObjectNamed:levelName withScreenSize:screenSize]) {
        BOOL** hitmaskarray = malloc(sizeof(BOOL*) * self.position->size.width);
        for (int i = 0; i<self.position->size.width; i++) {
            hitmaskarray[i] = malloc(sizeof(BOOL) * self.position->size.height);
            for (int j =0; j<self.position->size.height; j++) {
                hitmaskarray[i][j] = NO;
            }
        }
        
        for (int i = 0; i < self.position->size.width; i++) {
            //hitmaskarray[i][(int)self.position->size.height-1] = YES;
            hitmaskarray[i][15] = YES;
        }
        
        self.hitmask = [[SGHitMask alloc] initHitMaskWithBoolArray:hitmaskarray Width:self.position->size.width Height:self.position->size.height];
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



@end
