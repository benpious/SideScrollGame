//
//  SGAction.h
//  SideScrollGame
//
//  Created by Benjamin Pious on 12/20/12.
//  Copyright (c) 2012 Benjamin Pious. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>
#import "SGMassProtocol.h"

@interface SGAction : NSObject<SGMassProtocol>
@property (assign) CGRect area;
@property (assign) int damage;
@property (assign) GLfloat knockBack;
@property (assign) BOOL forceNextAnimation;
@property (retain) NSString* nextAction;

-(id) initWithArea: (CGRect) area Damage: (int) damage knockBack: (GLfloat) knockBack forceNextAnimation: (BOOL) forceNextAnimation nextAction: (NSString* ) nextAction;


@end
