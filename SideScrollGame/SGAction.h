//
//  SGAction.h
//  SideScrollGame
//
//  Created by Benjamin Pious on 12/20/12.
//  Copyright (c) 2012 Benjamin Pious. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>

@interface SGAction : NSObject
@property (assign) CGRect area;
@property (assign) float damage;
@property (assign) float knockBack;
@property (assign) BOOL forceNextAnimation;
@property (retain) NSString* nextAction;

-(id) initWithArea: (CGRect) area Damage: (float) damage knockBack: (float) knockBack forceNextAnimation: (BOOL) forceNextAnimation nextAction: (NSString* ) nextAction;


@end
