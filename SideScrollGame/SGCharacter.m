//
//  SGEntity.m
//  SideScrollGame
//
//  Created by Benjamin Pious on 12/15/12.
//  Copyright (c) 2012 Benjamin Pious. All rights reserved.
//

#import "SGCharacter.h"

@implementation SGCharacter
@synthesize hitmask;
@synthesize texture;
@synthesize effect;
@synthesize vertexCoords;
@synthesize textureCoords;
@synthesize fallSpeed;
@synthesize isFalling;
@synthesize width;
@synthesize height;
@synthesize position;

#pragma Setup Methods
-(id) initCharacterNamed: (NSString*) name
{
    if (self = [super init]) {
        self.position = malloc(sizeof(CGRect));
        *(self.position) = CGRectMake(0.0f, 0.0f, 0.0f, 0.0f);
        currentAnimation = 0;
        currentFrame = 0;
        effect = [[GLKBaseEffect alloc] init];
        [self loadTexture:[name stringByAppendingString:@"TextureData.png"]];
        //load animation arrays
        [self loadAnimations: [name stringByAppendingString:@"AnimationData"]];
        [self populateArraysWithScaleFactor:1.0f XOffset:-0.5f YOffset:-0.5f];
        self.fallSpeed = 0.0f;
        self.isFalling = NO;
        movementX = 0.0f;
        movementY = 0.0f;
        //self.hitmask = [[SGHitMask alloc] initHitMaskWithFileNamed:[name stringByAppendingString: @"HitMask.hmk"] Width:self.width Height:self.height];
        
        // test code delete later
        
        BOOL** hitmaskarray = malloc(sizeof(BOOL*) * self.width);
        for (int i =0; i<self.width; i++) {
            hitmaskarray[i] = malloc(sizeof(BOOL) * self.height);
            for (int j =0; j<self.height; j++) {
                hitmaskarray[i][j] = YES;
            }
        }
        self.hitmask = [[SGHitMask alloc] initHitMaskWithBoolArray:hitmaskarray Width:self.width Height:self.height];
        
        for (int i =0; i<self.width; i++) {
            free(hitmaskarray[i]);
        }
        
        free(hitmaskarray);
        
        // end test code
    }
    
    return self;
}


-(void) loadAnimations: (NSString*) plistName
{
    NSPropertyListFormat format;
    NSString* error = nil;
    NSString* path = [[NSBundle mainBundle] pathForResource:plistName ofType:@".plist"];
    NSData* plistXML = [[NSFileManager defaultManager] contentsAtPath:path];
    NSArray* animationArray = (NSArray*)[NSPropertyListSerialization propertyListWithData:plistXML options:NSPropertyListImmutable format:&format error:nil];
    
    animations = malloc(sizeof(animation*) * [animationArray count]);
    
    for (int i = 0; i < [animationArray count]; i++) {
        
        NSArray* temp = [animationArray objectAtIndex:i];
                
        animation* currAnimation = malloc(sizeof(animation));
        currAnimation->name = [temp objectAtIndex:0];
        currAnimation->duration = [[temp objectAtIndex:1] intValue];
        self.width = [[temp objectAtIndex:2] floatValue];
        self.height = [[temp objectAtIndex:3] floatValue];
        currAnimation->xOffset = [[temp objectAtIndex:4] floatValue] ;
        currAnimation->yOffset = [[temp objectAtIndex:5] floatValue] ;
        
        
        currAnimation->coords = malloc(sizeof(GLfloat*) * (currAnimation->duration));
        
        for (int j = 6; (j - 6) < currAnimation->duration; j++) {
            currAnimation->coords[j - 6] = [self glFloatArrayFromOriginX:[[[temp objectAtIndex: j]objectAtIndex: 0] floatValue] OriginY:[[[temp objectAtIndex: j]objectAtIndex: 1] floatValue]];
            
        }
        
        animations[i] = currAnimation;
        
    }

    //handle the error
    
    if (error != nil) {
        NSLog(@"error reading plist");
    }
    
   
    textureCoords = animations[0]->coords[0];
}

/*
 loads the texture, sets up the glkit base effect
 */
-(void) loadTexture: (NSString*) imageName
{
    //load the texture
    NSError *error = nil;
    NSDictionary* textureOps = @{GLKTextureLoaderApplyPremultiplication : @NO, GLKTextureLoaderGenerateMipmaps : @NO, GLKTextureLoaderOriginBottomLeft : @YES};
    NSString* imageNameFullPath = [[NSBundle mainBundle]
                           pathForResource:imageName ofType: nil];
    self.texture = [GLKTextureLoader textureWithContentsOfFile: imageNameFullPath options:textureOps error:&error];
    
    if (error != nil) {
        NSLog(@"error, %d", [error code]);
    }
    
    if (self.texture == nil) {
        NSLog(@"error, texture is nil");
    }

    self.effect.texture2d0.envMode = GLKTextureEnvModeReplace;
    self.effect.texture2d0.target = GLKTextureTarget2D;
    self.effect.texture2d0.name = texture.name;
    self.effect.light0.enabled = GL_TRUE;
    self.effect.light0.diffuseColor = GLKVector4Make(1.0f, 0.4f, 0.4f, 1.0f);

}

-(void) loadNormalMap: (NSString*) normalMapName
{
    //load the texture
    NSError *error = nil;
    NSDictionary* textureOps = @{GLKTextureLoaderApplyPremultiplication : @NO, GLKTextureLoaderGenerateMipmaps : @NO, GLKTextureLoaderOriginBottomLeft : @YES};
    NSString* normalsNameFullPath = [[NSBundle mainBundle]
                                   pathForResource:normalMapName ofType: nil];
    GLKTextureInfo* normals = [GLKTextureLoader textureWithContentsOfFile: normalsNameFullPath options:textureOps error:&error];
    
    if (error != nil) {
        NSLog(@"error, %d", [error code]);
    }
    
    if (self.texture == nil) {
        NSLog(@"error, texture is nil");
    }
    
    self.effect.texture2d1.envMode = GLKTextureEnvModeReplace;
    self.effect.texture2d1.target = GLKTextureTarget2D;
    self.effect.texture2d1.name = normals.name;
}


-(void) dealloc
{
    //loop through freeing all animations
    for (int i=0; i<numAnimations; i++) {
        //free memory allocated in animation struct
        for (int j = 0 ; j < animations[i]->duration; j++) {
            free(animations[i]->coords[j]);
            //free(animations[i]->animationHitmasks[j]);
        }
        free(animations[i]->coords);
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
    
    GLfloat xpercent = x / self.texture.width;
    GLfloat ypercent = y / self.texture.height;
    GLfloat xwidthpercent = (x + self.width) / self.texture.width;
    GLfloat yheightpercent = (y + self.height) / self.texture.height;
    
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

/*
 populates the vertexcoords array
 all of these arrays start at 0,0, then we can transform them to their proper place
 */
-(void) populateArraysWithScaleFactor: (GLfloat) scaleFactor XOffset: (GLfloat) xOffSet YOffset: (GLfloat) yOffset
{
    
    self.position->size.width = self.width * scaleFactor;
    self.position->size.height = self.height * scaleFactor;

    self.vertexCoords = malloc(sizeof(GLfloat) * 18);
    
    
    GLfloat proportion;
    
    //this if statement ensures that the vertex coords array is at the right proportion
    if (self.width < self.height) {
        proportion = self.height/self.width;
        
        self.vertexCoords[0] = 1.0f*scaleFactor + xOffSet;
        self.vertexCoords[1] = proportion*scaleFactor + yOffset;
        self.vertexCoords[3] = 0.0f*scaleFactor + xOffSet;
        self.vertexCoords[4] = 0.0f*scaleFactor + yOffset;
        self.vertexCoords[6] = 0.0f*scaleFactor + xOffSet;
        self.vertexCoords[7] = proportion*scaleFactor + yOffset;
        self.vertexCoords[9] = 1.0f*scaleFactor + xOffSet;
        self.vertexCoords[10] = proportion*scaleFactor + yOffset;
        self.vertexCoords[12] = 1.0f*scaleFactor + xOffSet;
        self.vertexCoords[13] = 0.0f + yOffset;
        self.vertexCoords[15] = 0.0f + xOffSet;
        self.vertexCoords[16] = 0.0f + yOffset;
    }
    
    else {
        
        proportion = self.width/self.height;
        self.vertexCoords[0] = proportion*scaleFactor + xOffSet;
        self.vertexCoords[1] = 1.0f*scaleFactor + yOffset;
        self.vertexCoords[3] = 0.0f*scaleFactor + xOffSet;
        self.vertexCoords[4] = 0.0f*scaleFactor + yOffset;
        self.vertexCoords[6] = 0.0f*scaleFactor + xOffSet;
        self.vertexCoords[7] = 1.0f*scaleFactor + yOffset;
        self.vertexCoords[9] = proportion*scaleFactor + xOffSet;
        self.vertexCoords[10] = 1.0f*scaleFactor + yOffset;
        self.vertexCoords[12] = proportion*scaleFactor + xOffSet;
        self.vertexCoords[13] = 0.0f*scaleFactor + yOffset;
        self.vertexCoords[15] = 0.0f*scaleFactor + xOffSet;
        self.vertexCoords[16] = 0.0f*scaleFactor + yOffset;
        
        
    }
    
    //fill the z coords with 0s
    for (int i = 0; i <= 5 ; i++) {
        self.vertexCoords[i*3+2] = 0.0f;
    }
    
}


#pragma Methods for the game engine


//test method -- delete later, move logic to character
-(void) setNextAnimation: (int) animation
{
    currentAnimation = animation;
}

/*
 moves to the next frame in the current animation
 note that this method does NOT change the opengl texture array pointer to texcoords -- 
 this must be done after this method is called -- it is currently done in ViewController before drawing
 */
-(void)nextFrame
{
    //loop to the beginning of the animation if we're finished with it
    if (currentFrame +1 > animations[currentAnimation]->duration-1) {
        currentFrame = 0;
    }
    
    else {
            currentFrame++;
    }

    textureCoords = animations[currentAnimation]->coords[currentFrame];
    
    movementX += animations[currentAnimation]->xOffset;
    movementY += animations[currentAnimation]->yOffset - self.fallSpeed;
    
    
    self.effect.transform.projectionMatrix = GLKMatrix4MakeTranslation(movementX, movementY, 0);
    self.position->origin.x = movementX;
    self.position->origin.y = movementY;
}

-(void) applyActionEffect: (SGAction*) action
{
    self.health -= action.damage;
    movementX -= action.knockBack;
}

@end
