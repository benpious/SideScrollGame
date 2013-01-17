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

@interface SGObjectEntity : NSObject<SGEntityProtocol, SGMassProtocol>

-(id) initObjectNamed: (NSString*) name;

@end
