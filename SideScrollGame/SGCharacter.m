//
//  SGEntity.m
//  SideScrollGame
//
//  Created by Benjamin Pious on 12/15/12.
//  Copyright (c) 2012 Benjamin Pious. All rights reserved.
//

#import "SGCharacter.h"

@implementation SGCharacter
@synthesize texture;
@synthesize effect;
@synthesize vertexCoords;
@synthesize textureCoords;

#pragma Setup Methods
-(id) initCharacterNamed: (NSString*) name
{
    if (self = [super init]) {

        [self loadTexture:[name stringByAppendingString:@"Texture.png"] ];
        //load animation arrays
        [self loadAnimations: [name stringByAppendingString:@"AnimationData"]];
    }
    
    return self;
}


-(void) loadAnimations: (NSString*) plistName
{
    NSPropertyListFormat format;
    NSString* error = nil;
    NSString* path = [[NSBundle mainBundle] pathForResource:plistName ofType:@".plist"];
    NSData* plistXML = [[NSFileManager defaultManager] contentsAtPath:path];
    NSArray* animationArray = [NSPropertyListSerialization propertyListWithData:plistXML options:NSPropertyListImmutable format:&format error:nil];
    
    for (int i=0; i < [animationArray count] ; i++) {
        
        NSArray* temp = [animationArray objectAtIndex:i];
        animation* currAnimation = malloc(sizeof(animation));
        currAnimation->name = [temp objectAtIndex:0];
        currAnimation->duration = (int)[temp objectAtIndex:1];
        
    }
    
    //handle the error
    if (error != nil) {
        NSLog(@"error reading plist");
    }
    
    [path release];
}

-(void) loadTexture: (NSString*) imageName
{
    //load the texture
    NSError *error = nil;
    NSDictionary* textureOps = @{GLKTextureLoaderApplyPremultiplication : @NO, GLKTextureLoaderGenerateMipmaps : @NO, GLKTextureLoaderOriginBottomLeft : @YES};
    NSString* imageNameFullPath = [[NSBundle mainBundle]
                           pathForResource:imageName ofType: nil];
    texture = [GLKTextureLoader textureWithContentsOfFile: imageNameFullPath options:textureOps error:&error];
    
    if (error != nil) {
        NSLog(@"error, %d", [error code]);
    }
    
    if (texture == nil) {
        NSLog(@"error, texture is nil");
    }

    
    [imageNameFullPath release];
    
    [texture retain];
    
}

-(void) populateArrays
{
    
    vertexCoords = malloc(sizeof(GLfloat) * 18);

    
    GLfloat proportion;
    
    if (width > height) {
        proportion = width/height;
        
        vertexCoords[0] = 1;
        vertexCoords[1] = proportion;
        vertexCoords[3] = 0.0f;
        vertexCoords[4] = 0.0f;
        vertexCoords[6] = 0.0f;
        vertexCoords[7] = proportion;
        vertexCoords[9] = 1;
        vertexCoords[10] = 0.0f;
        vertexCoords[12] = 1;
        vertexCoords[13] = proportion;
        vertexCoords[15] = 0.0f;
        vertexCoords[16] = 0.0f;
    }
    
    else {
        
        proportion = height/width;
        vertexCoords[0] = proportion;
        vertexCoords[1] = 1;
        vertexCoords[3] = 0.0f;
        vertexCoords[4] = 0.0f;
        vertexCoords[6] = 0.0f;
        vertexCoords[7] = 1;
        vertexCoords[9] = proportion;
        vertexCoords[10] = 0.0f;
        vertexCoords[12] = proportion;
        vertexCoords[13] = 1;
        vertexCoords[15] = 0.0f;
        vertexCoords[16] = 0.0f;
    
        
    }
    
    //fill the z coords with 0s
    for (int i =1; i <= 6 ; i++) {
        vertexCoords[i*3] = 0.0f;
    }
    
    
    
}

-(void) dealloc
{
    for (int i=0; i<numAnimations; i++) {
        //free memory allocated in animation struct
        for (int j = 0 ; j < animation[i].duration; j++) {
            free(animation[i].coords[j]);
            free(animation[i].coords);
        }
        free(animations[i]);
    }
    
    free(animations);
    free(vertexCoords);
    free(textureCoords);
    [effect release];
    [texture release];
    
    [super dealloc];
}

#pragma Utility methods to create opengl arrays from rectangles

//makes a glfloat array which will be used to draw a part of the texture image as a frame of animation
-(GLfloat*) glFloatArrayFromOriginX: (GLfloat) x OriginY: (GLfloat) y
{
    GLfloat* arrayf = malloc(sizeof(GLfloat) * 12);
    
    arrayf[0] = x + width;
    arrayf[1] = y + height;
    arrayf[2] = x;
    arrayf[3] = y;
    arrayf[4] = x;
    arrayf[5] = y + height;
    arrayf[6] = x + width;
    arrayf[7] = y + height;
    arrayf[8] = x + width;
    arrayf[9] = y;
    arrayf[10] = x;
    arrayf[11] = y;
    
    return arrayf;
}

#pragma Accessors for the game engine

@end
