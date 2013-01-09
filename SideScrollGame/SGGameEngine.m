//
//  SGGameEngine.m
//  SideScrollGame
//
//  Created by Benjamin Pious on 12/15/12.
//  Copyright (c) 2012 Benjamin Pious. All rights reserved.
//

#import "SGGameEngine.h"

@implementation SGGameEngine
@synthesize objects;
@synthesize characters;

//call whenever an action is made
-(BOOL)hitDetectedBetween: (NSObject<SGEntityProtocol>*) a and: (NSObject<SGEntityProtocol>*) b
{
    //get the vertexarrays of a and b with their transforms applied
    
    //test if squares intersect
    return [self squaresIntersect:a.vertexCoords :b.vertexCoords];
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
        [self loadPlistWithName:levelName];
    }
    
    return self;
}

-(void) playerActionReceived
{
    
}

/*
 Loads the level from a given .plist file
 The format is this: an array with an array inside it for each object or character
 Each of these arrays has the name of the file to be loaded, plus a label stating if it is a character
 or an object
 */
-(void) loadPlistWithName: (NSString*) levelName
{
    NSPropertyListFormat format;
    NSString* error = nil;
    NSString* path = [[NSBundle mainBundle] pathForResource:levelName ofType:@".plist"];
    NSData* plistXML = [[NSFileManager defaultManager] contentsAtPath:path];
    NSArray* entityArray = (NSArray*)[NSPropertyListSerialization propertyListWithData:plistXML options:NSPropertyListImmutable format:&format error:nil];
    
    if (error != nil) {
        NSLog(@"error reading plist");
        return;
    }
    
    characters = [[NSMutableArray alloc] initWithCapacity:[entityArray count]/2];
    objects = [[NSMutableArray alloc] initWithCapacity:[entityArray count]/2];
    for (int i = 0; i< [entityArray count]; i++) {
        NSArray* currentEntity = [entityArray objectAtIndex:i];
        
        if ([currentEntity objectAtIndex:1] == @"character") {
            [characters insertObject: [[SGCharacter alloc] initCharacterNamed: [currentEntity objectAtIndex:0]] atIndex:[characters count]] ;
        }
        
        else {
            [objects  insertObject: [[SGObjectEntity alloc] initObjectNamed: [currentEntity objectAtIndex:0]] atIndex:[objects count]] ;
        }
    }
}

//called whenever the openglview's update function fires
-(void) eventLoopCallBack
{
    
    //make the gamestate array TODO: should include level
    NSArray* state = [[NSArray alloc] initWithObjects:characters, objects, nil];

    //loop through all the characters
    for(SGCharacter* currChar in characters)
    {
        ;
    
        //request an action from each one
        if ([currChar respondsToSelector:NSSelectorFromString( @"requestMoveWithGameState:")]) {
            [actionQueue offer: [currChar requestMoveWithGameState: state]];
        }
        //apply gravity if applicable
        [self applyGravityTo:currChar];
    
    }
    
    
    //loop through the action queue applying the results
    while (actionQueue.length != 0) {
        SGAction* action = [actionQueue pop];
        
        
    }

}

-(void) applyGravityTo: (NSObject<SGEntityProtocol>*) object
{
    object.fallSpeed += gravitySpeed;
    object.effect.transform.modelviewMatrix = GLKMatrix4MakeTranslation(0.0f, object.fallSpeed, 0.0f);
}

-(void) requestActionFromCharacter: (SGCharacter<SGAgentProtocol>*) character
{
    
    
    //[character requestMoveWithGameState: ];
}

-(void) applyJoystickMovewithAngle: (GLfloat) angle
{
    
    
}

-(void) applyTouchDownWithLocation:(CGPoint) loc
{
    
}

-(void) applyTouchUpWithLocation: (CGPoint) loc
{
    
}


//returns an array of objects to draw. The object receiving the array should release it at the end of its usefulness
-(NSMutableArray*) objectsToDraw
{
    NSMutableArray* toReturn = [[NSMutableArray alloc] initWithArray:characters];
    [toReturn addObjectsFromArray:objects];
    return toReturn;
    
}

@end
