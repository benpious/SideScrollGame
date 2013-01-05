//
//  SGHitMaskManager.h
//  SideScrollGame
//
//  Created by Benjamin Pious on 1/5/13.
//  Copyright (c) 2013 Benjamin Pious. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SGHitMaskManager : NSObject

+(BOOL)collisionBetweenHitmask: (char*) a WithSize: (CGSize) aSize Hitmask: (char*) b  WithSize: (CGSize) bSize withOffsetX: (GLfloat) x OffsetY: (GLfloat) y;

+(char*) loadHitmaskWithFileName: (NSString*) name;


+(char*) resizeHitmask: (char*) mask NewX: (GLfloat) x NewY: (GLfloat) y;

@end
