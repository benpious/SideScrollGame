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
#import "LevelNavStructs.h"
#import "SGQueue.h"

/*
 Subclasses and extends SGObjectEntity, adding features necessary for loading a level
 Note that the level is just the world, and not any of the objects in it, those are loaded in the gameengine
 */
@interface SGLevel : SGObjectEntity
{
    GLfloat changePoint;
    
}
-(id) initWithLevelPlistNamed: (NSString*) levelName withScreenSize: (CGRect) screenSize;


@end
