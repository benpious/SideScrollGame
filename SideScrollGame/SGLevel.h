//
//  SGLevel.h
//  SideScrollGame
//
//  Created by Benjamin Pious on 1/4/13.
//  Copyright (c) 2013 Benjamin Pious. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SGObjectEntity.h"
#import "SGAction.h"

typedef struct levelNode  levelNode;
typedef struct levelPath levelPath;

/*
 for the benefit of the AI -- this struct contains info about 
 a path from one node to another
 the point is the point on the node that the AI should use to move, 
 and the action is the action the AI should take to reach that node
 */
struct levelPath {
    levelNode* nextNode;
    float point;
    SGAction* action;
};

struct levelNode {
    levelPath** leaves;
    int numLeaves;
    id data;
    
};



@interface SGLevel : SGObjectEntity
{
    GLfloat changePoint;
}
-(id) initWithLevelPlistNamed: (NSString*) levelName withScreenSize: (CGRect) screenSize;


@end
