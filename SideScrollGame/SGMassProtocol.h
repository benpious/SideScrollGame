//
//  SGMassProtocol.h
//  SideScrollGame
//
//  Created by Benjamin Pious on 1/15/13.
//  Copyright (c) 2013 Benjamin Pious. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SGHitMask.h"
/*
 Objects which conform to this protocol can be tested for collisions
 */
@protocol SGMassProtocol <NSObject>
@property (retain) SGHitMask* hitmask;
@property (assign) CGRect* position;
@end
