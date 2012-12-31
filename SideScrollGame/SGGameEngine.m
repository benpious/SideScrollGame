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
    //get the vertexarrays of a and b with their transforms applied
    
    //test if squares intersect
    
        //if they do, do pixel perfect test with masks
    
    return NO;
}

-(BOOL) squaresIntersect: (GLfloat*) a : (GLfloat*) b
{
    //test if the x coordinates intersect
    if ((a[0] < b[0] || a[0] > b[0]) && ( a[4] < b[4] || a[4] > b[4] )) {
        return NO;
    }
    
    //test if the y coordinates intersect
    if ((a[1] < b[1] || a[1] > b[1]) && (a[6] < b[6] || a[6] > b[6])) {
        return NO;
    }
    
    return YES;
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

-(void) loadPlistWithName: (NSString*) levelName
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
