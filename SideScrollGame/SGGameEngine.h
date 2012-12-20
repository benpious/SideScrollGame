//
//  SGGameEngine.h
//  SideScrollGame
//
//  Created by Benjamin Pious on 12/15/12.
//  Copyright (c) 2012 Benjamin Pious. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SGCharacter.h"
#import "SGViewController.h"
#import "SGQueue.h"

@interface SGGameEngine : NSObject
{
    SGQueue* actionQueue;
}

@property (retain) NSMutableArray* characters;
@property (assign) SGCharacter* player;

@end
