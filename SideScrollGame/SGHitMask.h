//
//  SGHitMaskManager.h
//  SideScrollGame
//
//  Created by Benjamin Pious on 1/5/13.
//  Copyright (c) 2013 Benjamin Pious. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SGHitMask : NSObject

@property (assign) BOOL** hitmask;

@property (assign) int width;
@property (assign) int height;



-(id) initHitMaskWithFileNamed: (NSString*) name Width: (int) width Height: (int) height;
-(id) initHitmaskWithHitmask: (SGHitMask*) oldHitmask Partition: (CGRect) partition OldHitMaskOrigin: (CGPoint) hitMaskOrigin;
-(id) initHitMaskWithBoolArray: (BOOL**) oldHitmask Width: (int) width Height: (int) height;

+(BOOL) collisionBetweenEquallySizedHitmasks: (SGHitMask*) a And: (SGHitMask*) b;

@end
