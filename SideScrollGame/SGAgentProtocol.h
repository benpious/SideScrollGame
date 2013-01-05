//
//  SGAgentProtocol.h
//  SideScrollGame
//
//  Created by Benjamin Pious on 1/3/13.
//  Copyright (c) 2013 Benjamin Pious. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SGAction.h"

/*
    unlike the character, action, and object classes, which should not be subclassed but instead read from plist files
    agent logic is implemented in classes which conform to the agent protocol
 */

@protocol SGAgentProtocol <NSObject>
/*agents can send other agents order messages
 an order message returns a bool indicating whether the other
 agent will  comply with the order or not
 */

//dictionary of the actions currently available
@property (retain) NSDictionary* actions;

-(BOOL) flankOrder;
-(BOOL) attackOrder;
-(BOOL) waitOrder;
-(SGAction*) requestMoveWithGameState: (NSArray*) gameState;

@end
