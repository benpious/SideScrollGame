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
@synthesize player;
@synthesize level;

#pragma mark hit dectection
//call whenever an action is made
-(BOOL)hitDetectedBetween: (NSObject<SGMassProtocol> const * const) a and: (NSObject<SGMassProtocol>const * const) b
{
    CGRect partition = CGRectIntersection(*(a.position), *(b.position));
    
    if (CGRectIsNull(partition)) {
        return NO;
    
    }
    
    SGHitMask* aMask = [[SGHitMask alloc] initHitmaskWithHitmask:a.hitmask Partition:partition OldHitMaskOrigin:a.position->origin];
    SGHitMask* bMask = [[SGHitMask alloc] initHitmaskWithHitmask:b.hitmask Partition:partition OldHitMaskOrigin:b.position->origin];
    
    if ([SGHitMask collisionBetweenEquallySizedHitmasks:aMask And:bMask]) {
        
        [aMask release];
        [bMask release];
        return YES;
    }
    
    [aMask release];
    [bMask release];

    return NO;
}


#pragma mark level initialiazation

-(id) initWithLevelPlist: (NSString*) levelName ScreenSize:(CGRect)screenSize
{
    if (self = [super init]) {
        
        actionQueue = [[SGQueue alloc] init];
        [self loadPlistWithName:levelName withScreenSize:screenSize];
        joystick = [[SGJoystick alloc] initJoystickWithScreenSize:screenSize];
        gravitySpeed = .001;
        
    }
    
    return self;
}


/*
 Loads the level from a given .plist file
 The format is this: an array with an array inside it for each object or character
 Each of these arrays has the name of the file to be loaded, plus a label stating if it is a character
 or an object
 */
-(void) loadPlistWithName: (NSString*) levelName withScreenSize: (CGRect) screenSize
{
    
    level = [[SGLevel alloc] initWithLevelPlistNamed:levelName withScreenSize:screenSize];
    
    NSPropertyListFormat format;
    NSError* error = nil;
    NSString* path = [[NSBundle mainBundle] pathForResource:levelName ofType:@".plist"];
    NSData* plistXML = [[NSFileManager defaultManager] contentsAtPath:path];
    NSArray* entityArray = (NSArray*)[NSPropertyListSerialization propertyListWithData:plistXML options:NSPropertyListImmutable format:&format error:&error];
    
    if (error != nil) {
        NSLog(@"error reading plist");
        return;
    }
    
    characters = [[NSMutableArray alloc] initWithCapacity:[entityArray count]/2];
    objects = [[NSMutableArray alloc] initWithCapacity:[entityArray count]/2];
    for (int i = 0; i< [entityArray count]; i++) {
        NSArray* currentEntity = [entityArray objectAtIndex:i];
        
        if ([[currentEntity objectAtIndex:1] isEqualToString: @"Character"]) {
            //test code delete later
            //SGWalkAgent* walk = [[SGWalkAgent alloc] init];
            //walk.character =
            //end test code
            [characters insertObject: [[SGCharacter alloc] initCharacterNamed: [currentEntity objectAtIndex:0] withScreenSize:screenSize] atIndex:[characters count]] ;
        }
        
        else {
            
            if ([[currentEntity objectAtIndex:1] isEqualToString: @"Main"]) {
                [characters insertObject: [[SGMainCharacter alloc] initCharacterNamed: [currentEntity objectAtIndex:0] withScreenSize:screenSize] atIndex:[characters count]] ;
                player = [characters objectAtIndex:[characters count]-1];
            }
            else
            [objects  insertObject: [[SGObjectEntity alloc] initObjectNamed: [currentEntity objectAtIndex:0] withScreenSize:screenSize] atIndex:[objects count]] ;
        }
    }
    
    [objects insertObject:level atIndex:0];
}


#pragma mark callback related methods
//called whenever the openglview's update function fires
-(void) eventLoopCallBack
{
    //make the gamestate array TODO: should include level 
    NSArray* state = [[NSArray alloc] initWithObjects:characters, objects, nil];

    //loop through all the characters
    for(SGCharacter* currChar in characters)
    {
        [currChar nextFrame];
            
        //request an action from each one
        
        if ([currChar respondsToSelector:NSSelectorFromString( @"requestMoveWithGameState:")]) {
            [actionQueue offer: [currChar performSelector:NSSelectorFromString( @"requestMoveWithGameState:") withObject:state]];
        }
    
        
        //apply gravity if applicable
        [self applyGravityTo:currChar];
    
    }
    
    [self applyGravityTo: self.player];
    
    //loop through the action queue applying the results
    while (actionQueue.length != 0) {
        SGAction* action = [actionQueue pop];
        for (SGCharacter* currChar in characters) {
            if ([self hitDetectedBetween:currChar and: action ]) {
                [currChar applyActionEffect: action];
            }
        }
    }
    
    [state release];

}

-(void) applyGravityTo: (NSObject<SGEntityProtocol, SGMassProtocol>*) object
{
    
    if (![self hitDetectedBetween:self.level and:object]) {
        
        object.fallSpeed += gravitySpeed;
        
    }
    
    else object.fallSpeed = 0.0f;
}

//returns an array of objects to draw. The object receiving the array should release it at the end of its usefulness
-(NSMutableArray*) objectsToDraw
{
    NSMutableArray* toReturn = [[NSMutableArray alloc] initWithArray:objects];
    [toReturn addObjectsFromArray:characters];
    
    //test code, in the future, this will be handled on a per object to draw basis
    if (joystick.shouldDraw == YES) {
        [toReturn addObject:joystick];
    }
    //end test code
    
    return toReturn;
    
}

#pragma mark action methods

-(void) playerActionReceived
{
    
}

-(void) applyJoystickMovewithAngle: (GLfloat const ) angle XPos: (GLfloat const) xPos YPos: (GLfloat const) yPos Radians: (GLfloat const) radiansAngle Size:(CGSize const)size
{
    
    [joystick recieveJoystickInputWithAngle:radiansAngle XPos:  1-yPos/(size.height/2)  YPos:  1-xPos/(size.width/2) ];

    
    if (angle >= 45.0f && angle < 135.0f) {
        joystickDirection = backwards;
        [player receiveJoystickInput:joystickDirection];
        return;
    }
    
    if (angle >= 135.0f && angle < 225.0f) {
        joystickDirection = down;
        [player receiveJoystickInput:joystickDirection];
        return;
    }
    
    
    
    if (angle >= 225.0f && angle < 315.0f) {
        joystickDirection = forwards;
        [player receiveJoystickInput:joystickDirection];
        return;
    }
    
    if (angle >= 315.0f || angle < 45.0f) {
        joystickDirection = up;
        [player receiveJoystickInput:joystickDirection];
        return;
    }
    
}

-(void) applyTouchUpWithLocation: (CGPoint) loc
{
    [joystick joyStickInputStopped];
    [player setNextAnimation:idle];
}


//when there are buttons, this method will be used to send events to them if appropriate
-(void) applyTouchDownWithLocation:(CGPoint) loc
{
    
}

@end
