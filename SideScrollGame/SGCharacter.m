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
@synthesize fallSpeed;
@synthesize isFalling;

#pragma Setup Methods
-(id) initCharacterNamed: (NSString*) name
{
    if (self = [super init]) {
        
        currentAnimation = 0;
        currentFrame = 0;
        effect = [[GLKBaseEffect alloc] init];
        [self loadTexture:[name stringByAppendingString:@"TextureData.png"] ];
        //load animation arrays
        [self loadAnimations: [name stringByAppendingString:@"AnimationData"]];
        [self populateArrays];
        fallSpeed = 0.0f;
        isFalling = NO;
        
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
    animations = malloc(sizeof(animation*));
    
    for (int i=0; i < [animationArray count]; i++) {
        
        NSArray* temp = [animationArray objectAtIndex:i];
        animation* currAnimation = malloc(sizeof(animation));
        currAnimation->name = [temp objectAtIndex:0];
        currAnimation->duration = [[temp objectAtIndex:1] intValue];
        width = [[temp objectAtIndex:2] floatValue];
        height = [[temp objectAtIndex:3] floatValue];
        //currentAnimation->xOffset = [temp objectAtIndex:4]
        //currentAnimation->yOffset = [temp objectAtIndex:5]
        
        currAnimation->coords = malloc(sizeof(GLfloat*));
        
        for (int j=4; j-4<currAnimation->duration; j++) {
            currAnimation->coords[j-4] = [self glFloatArrayFromOriginX:[[[temp objectAtIndex: j]objectAtIndex: 0] floatValue] OriginY:[[[temp objectAtIndex: j]objectAtIndex: 1] floatValue]];
            
            animations[i] = currAnimation;
        }
        
    }

    //handle the error
    if (error != nil) {
        NSLog(@"error reading plist");
    }
    
    textureCoords = animations[0]->coords[0];    
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

    self.effect.texture2d0.envMode = GLKTextureEnvModeReplace;
    self.effect.texture2d0.target = GLKTextureTarget2D;
    self.effect.texture2d0.name = texture.name;
    self.effect.light0.enabled = GL_TRUE;
    self.effect.light0.diffuseColor = GLKVector4Make(1.0f, 0.4f, 0.4f, 1.0f);
    
}

-(void) populateArrays
{
    
    vertexCoords = malloc(sizeof(GLfloat) * 18);
    
    
    GLfloat proportion;
    
    if (width > height) {
        proportion = height/width;
        
        vertexCoords[0] = 1.0f;
        vertexCoords[1] = proportion;
        vertexCoords[3] = 0.0f;
        vertexCoords[4] = 0.0f;
        vertexCoords[6] = 0.0f;
        vertexCoords[7] = proportion;
        vertexCoords[9] = 1.0f;
        vertexCoords[10] = proportion;
        vertexCoords[12] = 1.0f;
        vertexCoords[13] = 0.0f;
        vertexCoords[15] = 0.0f;
        vertexCoords[16] = 0.0f;
    }
    
    else {
        
        proportion = width/height;
        vertexCoords[0] = proportion;
        vertexCoords[1] = 1.0f;
        vertexCoords[3] = 0.0f;
        vertexCoords[4] = 0.0f;
        vertexCoords[6] = 0.0f;
        vertexCoords[7] = 1.0f;
        vertexCoords[9] = proportion;
        vertexCoords[10] = 1.0f;
        vertexCoords[12] = proportion;
        vertexCoords[13] = 0.0f;
        vertexCoords[15] = 0.0f;
        vertexCoords[16] = 0.0f;
        
        
    }
    
    //fill the z coords with 0s
    for (int i = 0; i <= 5 ; i++) {
        vertexCoords[i*3+2] = 0.0f;
    }
    
}

-(void) dealloc
{
    for (int i=0; i<numAnimations; i++) {
        //free memory allocated in animation struct
        for (int j = 0 ; j < animations[i]->duration; j++) {
            free(animations[i]->coords[j]);
            free(animations[i]->coords);
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
    
    GLfloat xpercent = x / 140;
    GLfloat ypercent = y / 170;
    GLfloat xwidthpercent = (x + width) / 140;
    GLfloat yheightpercent = (y + height) / 170;
    
    arrayf[0] = xwidthpercent;
    arrayf[1] = yheightpercent;
    arrayf[2] = xpercent;
    arrayf[3] = ypercent;
    arrayf[4] = xpercent;
    arrayf[5] = yheightpercent;
    arrayf[6] = xwidthpercent;
    arrayf[7] = yheightpercent;
    arrayf[8] = xwidthpercent;
    arrayf[9] = ypercent;
    arrayf[10] = xpercent;
    arrayf[11] = ypercent;
    
    return arrayf;
}

#pragma Methods for the game engine

//moves to the next frame in the current animation
-(void)nextFrame
{
    if (currentFrame > animations[currentAnimation]->duration) {
        currentAnimation = 0;
        currentFrame = 0;
    }
    
    else {
        
        textureCoords = animations[currentAnimation]->coords[currentFrame];
        currentFrame++;
        self.effect.transform.modelviewMatrix = GLKMatrix4MakeTranslation(animations[currentAnimation]->xOffset, animations[currentAnimation]->yOffset, 0);
        
    }
    
    
}

@end
