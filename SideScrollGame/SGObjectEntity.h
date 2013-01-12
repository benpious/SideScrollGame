//
//  SGObjectEntity.h
//  SideScrollGame
//
//  Created by Benjamin Pious on 12/15/12.
//  Copyright (c) 2012 Benjamin Pious. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SGEntityProtocol.h"

@interface SGObjectEntity : NSObject<SGEntityProtocol>
@property (assign) GLfloat width;
@property (assign) GLfloat height;

-(id) initObjectNamed: (NSString*) name;

@end
