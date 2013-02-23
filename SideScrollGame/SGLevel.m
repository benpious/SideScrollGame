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
        
        self.hitmask = [[SGHitMask alloc] initHitMaskWithFileNamed:[levelName stringByAppendingString:@".hmk"] Width:self.width Height:self.height];
        
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
