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

//call whenever an action is made
-(BOOL)hitDetectedBetween: (NSObject<SGEntityProtocol>*) a and: (NSObject<SGEntityProtocol>*) b
{
    //get the vertexarrays of a and b with their transforms applied
    
    //test if squares intersect //TODO get transformed vertex coords
    return [self squaresIntersect:a.vertexCoords :b.vertexCoords];
        //if they do, do pixel perfect test with masks
    
    return NO;
}

//will only work if the two objects are on the screen
-(BOOL) intersectionBetween: (NSObject<SGEntityProtocol>*) a and: (NSObject<SGEntityProtocol>*) b
{
    CGRect aCoords;
    
    CGRect bCoords;
    
    if ((aCoords.origin.x < bCoords.origin.x && aCoords.size.width + aCoords.origin.x < bCoords.size.width + bCoords.origin.x)||(aCoords.origin.x > bCoords.origin.x && aCoords.size.width + aCoords.origin.x > bCoords.size.width + bCoords.origin.x)) {
        return NO;
    }
    
    if ((aCoords.origin.y < bCoords.origin.y && aCoords.size.height + aCoords.origin.y < bCoords.size.height + bCoords.origin.y) || (aCoords.origin.y > bCoords.origin.y && aCoords.size.height + aCoords.origin.y > bCoords.size.height + bCoords.origin.y)) {
    return NO;
    }
    
    

    
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
        joystick = [[SGJoystick alloc] initJoystick];
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
    
    level = [[SGLevel alloc] initWithLevelPlistNamed:levelName];
    
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
            [characters insertObject: [[SGCharacter alloc] initCharacterNamed: [currentEntity objectAtIndex:0]] atIndex:[characters count]] ;
        }
        
        else {
            
            if ([[currentEntity objectAtIndex:1] isEqualToString: @"Main"]) {
                [characters insertObject: [[SGMainCharacter alloc] initCharacterNamed: [currentEntity objectAtIndex:0]] atIndex:[characters count]] ;
                player = [characters objectAtIndex:[characters count]-1];
            }
            else
            [objects  insertObject: [[SGObjectEntity alloc] initObjectNamed: [currentEntity objectAtIndex:0]] atIndex:[objects count]] ;
        }
    }
    
    [objects insertObject:level atIndex:0];
}

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
    
    
    //loop through the action queue applying the results
    while (actionQueue.length != 0) {
        SGAction* action = [actionQueue pop];
        
    }

}

-(void) applyGravityTo: (NSObject<SGEntityProtocol>*) object
{
    
    if ([self hitDetectedBetween:self.level and:object]) {
        
        object.fallSpeed += gravitySpeed;
        object.effect.transform.projectionMatrix = GLKMatrix4Multiply(object.effect.transform.projectionMatrix ,GLKMatrix4MakeTranslation(0.0f, object.fallSpeed, 0.0f));
        
    }
}


-(void) applyJoystickMovewithAngle: (GLfloat) angle XPos: (GLfloat) xPos YPos: (GLfloat) yPos Radians: (GLfloat) radiansAngle Size:(CGSize)size
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

-(void) applyTouchDownWithLocation:(CGPoint) loc
{
    
}

-(void) applyTouchUpWithLocation: (CGPoint) loc
{
    [joystick joyStickInputStopped];
}


//returns an array of objects to draw. The object receiving the array should release it at the end of its usefulness
-(NSMutableArray*) objectsToDraw
{
    NSMutableArray* toReturn = [[NSMutableArray alloc] initWithArray:objects];
    [toReturn addObjectsFromArray:characters];
    
    //test code
    if (joystick.shouldDraw == YES) {
        [toReturn addObject:joystick];
    }
    
    
    return toReturn;
    
}

@end
