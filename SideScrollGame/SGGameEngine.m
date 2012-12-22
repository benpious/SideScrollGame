//
//  SGGameEngine.m
//  SideScrollGame
//
//  Created by Benjamin Pious on 12/15/12.
//  Copyright (c) 2012 Benjamin Pious. All rights reserved.
//

#import "SGGameEngine.h"

@implementation SGGameEngine

//call whenever an action is made
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
    
    for(SGCharacter* currChar in _characters)
    {
        ;
    
        //request an action from each one
    
        //apply gravity if applicable
        [self applyGravityTo:currChar];
    
    }
    
    
    //loop through the action queue applying the results
    

}

-(void) applyGravityTo: (NSObject<SGEntityProtocol>*) object
{
    object.fallSpeed += gravitySpeed;
    object.effect.transform.modelviewMatrix = GLKMatrix4MakeTranslation(0.0f, object.fallSpeed, 0.0f);
}

-(void) requestActionFromCharacter: (SGCharacter*) character
{
    
}

@end
