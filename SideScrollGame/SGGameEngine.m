//
//  SGGameEngine.m
//  SideScrollGame
//
//  Created by Benjamin Pious on 12/15/12.
//  Copyright (c) 2012 Benjamin Pious. All rights reserved.
//

#import "SGGameEngine.h"

@implementation SGGameEngine

-(BOOL)hitDetectedBetween: (NSObject<SGEntityProtocol>*) a and: (NSObject<SGEntityProtocol>*) b
{
    return NO;
}

-(id) initWithLevelPlist: (NSString*) levelName
{
    if (self = [super init]) {
        actionQueue = [[SGQueue alloc] init];
        
    }
    
    return self;
}

-(void) playerActionReceived
{
    
}

//called whenever the openglview's update function fires
-(void) eventLoopCallBack
{
    //loop through all the characters
    
        //request an action from each one
    
        //apply gravity if applicable
    
    //loop through the action queue applying the results
}

-(void) applyGravityTo: (NSObject<SGEntityProtocol>*) object
{
    
}

-(void) requestActionFromCharacter: (SGCharacter*) character
{
    
}

@end
