//
//  SGStaticAgent.h
//  SideScrollGame
//
//  Created by Benjamin Pious on 1/5/13.
//  Copyright (c) 2013 Benjamin Pious. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SGAgentProtocol.h"

@interface SGStaticAgent : NSObject<SGAgentProtocol>
{
    SGAction* noAction;
}

@end
