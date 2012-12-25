//
//  SGCharacterAgent.h
//  SideScrollGame
//
//  Created by Benjamin Pious on 12/25/12.
//  Copyright (c) 2012 Benjamin Pious. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SGCharacterAgent <NSObject>

-(SGAction*) chooseAction;

@end
