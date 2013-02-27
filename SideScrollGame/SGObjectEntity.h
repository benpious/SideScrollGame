//
//  SGObjectEntity.h
//  SideScrollGame
//
//  Created by Benjamin Pious on 12/15/12.
//  Copyright (c) 2012 Benjamin Pious. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SGEntityProtocol.h"
#import "SGMassProtocol.h"

/*
 This class is for anything that doesn't need to be animated and is just a static object
 */
@interface SGObjectEntity : NSObject<SGEntityProtocol, SGMassProtocol>

-(id) initObjectNamed: (NSString*) name withScreenSize: (CGRect) screenSize;

@end
