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
@synthesize fallSpeed;
@synthesize isFalling;
@synthesize width;
@synthesize height;
@synthesize position;
@synthesize drawingInfo;
@synthesize normals;

#pragma Setup Methods
-(id) initCharacterNamed: (NSString*) name withScreenSize:(CGRect)screenSize
{
    if (self = [super init]) {
        self.position = malloc(sizeof(CGRect));
        *(self.position) = CGRectMake(0.0f, 0.0f, 0.0f, 0.0f);
        currentAnimation = idle;
        currentFrame = 0;
        self.drawingInfo = calloc(1 , sizeof(drawInfo));
        [self loadTexture:[name stringByAppendingString:@"TextureData.png"]];
        
        [self loadNormalMap:[name stringByAppendingString:@"NormalData.png"]];
        
        //load animation arrays
        [self loadAnimations: name];
                
        [self populateArraysWithScaleFactor:1.0f XOffset:-0.5f YOffset:-0.5f screenSize: screenSize];
        self.fallSpeed = 0.0f;
        self.isFalling = NO;
        movementX = 0.0f;
        movementY = 0.0f;
    }
    
    return self;
}

//loads animations and hitmasks -- should consider changing the name....
-(void) loadAnimations: (NSString*) plistName
{
    NSPropertyListFormat format;
    NSString* error = nil;
    NSString* path = [[NSBundle mainBundle] pathForResource:[plistName stringByAppendingString:@"AnimationData"] ofType:@".plist"];
    NSData* plistXML = [[NSFileManager defaultManager] contentsAtPath:path];
    NSArray* animationArray = (NSArray*)[NSPropertyListSerialization propertyListWithData:plistXML options:NSPropertyListImmutable format:&format error:nil];
    
    SGHitMask* overallHitmask = [[SGHitMask alloc] initHitMaskWithFileNamed:plistName Width: texture.width Height:texture.height];

    animations = malloc(sizeof(animation*) * [animationArray count]);
    
    for (int i = 0; i < [animationArray count]; i++) {
        
        NSArray* temp = [animationArray objectAtIndex:i];
                
        animation* currAnimation = malloc(sizeof(animation));
        currAnimation->name = [temp objectAtIndex:0];
        currAnimation->duration = [[temp objectAtIndex:1] intValue];
        //the next two lines are an issue, don't know what the hell I was thinking here.... this should be set once, and remain constant
        self.width = [[temp objectAtIndex:2] floatValue];
        self.height = [[temp objectAtIndex:3] floatValue];
        currAnimation->xOffset = [[temp objectAtIndex:4] floatValue];
        currAnimation->yOffset = [[temp objectAtIndex:5] floatValue];
        
        
        currAnimation->coords = malloc(sizeof(GLuint) * (currAnimation->duration));
        currAnimation->animationHitmasks = malloc(sizeof(SGHitMask*) * (currAnimation->duration));
        
        for (int j = 6; (j - 6) < currAnimation->duration; j++) {
            GLfloat* textureCoords = [self glFloatArrayFromOriginX:[[[temp objectAtIndex: j]objectAtIndex: 0] floatValue] OriginY:[[[temp objectAtIndex: j]objectAtIndex: 1] floatValue]];
                        
            currAnimation->animationHitmasks[j-6] = [[SGHitMask alloc] initHitmaskWithHitmask:overallHitmask Partition:CGRectMake([[[temp objectAtIndex: j]objectAtIndex: 1] floatValue], [[[temp objectAtIndex: j]objectAtIndex: 0] floatValue], self.height, self.width) OldHitMaskOrigin:CGPointMake(0.0, 0.0)];
            
            glGenBuffers(1, &(currAnimation->coords[j-6]));
            glBindBuffer(GL_ARRAY_BUFFER, currAnimation->coords[j-6]);
            glBufferData(GL_ARRAY_BUFFER, sizeof(GLfloat)*12, textureCoords, GL_STATIC_DRAW);
            free(textureCoords);
            
        }
        
        animations[i] = currAnimation;
        
    }

    //handle the error
    
    if (error != nil) {
        NSLog(@"error reading plist");
    }
    
    [overallHitmask release];
    
    //set the texturevertices for the first time
    drawingInfo->textureVertices = animations[currentAnimation]->coords[currentFrame];
    self.hitmask = animations[currentAnimation]->animationHitmasks[currentFrame];
    

}

/*
 loads the texture
 */
-(void) loadTexture: (NSString*) imageName
{
    /*if there is a glerror reported when this method enters it will fail to load the texture
     therefore, get the error just so that opengl won't fail -- obviously this isn't a great solution*/
    glGetError();
    
    //load the texture
    NSError *error = nil;
    NSDictionary* textureOps = @{GLKTextureLoaderApplyPremultiplication : @NO, GLKTextureLoaderGenerateMipmaps : @NO, GLKTextureLoaderOriginBottomLeft : @YES};
    NSString* imageNameFullPath = [[NSBundle mainBundle] pathForResource:imageName ofType: nil];
    self.texture = [GLKTextureLoader textureWithContentsOfFile: imageNameFullPath options:textureOps error:&error];
    
    if (error != nil) {
        NSLog(@"error, %d", [error code]);
    }
    
    if (self.texture == nil) {
        NSLog(@"error, texture is nil");
    }

}

-(void) loadNormalMap: (NSString*) normalMapName
{
    //load the texture
    NSError *error = nil;
    NSDictionary* textureOps = @{GLKTextureLoaderApplyPremultiplication : @NO, GLKTextureLoaderGenerateMipmaps : @NO, GLKTextureLoaderOriginBottomLeft : @YES};
    NSString* normalsNameFullPath = [[NSBundle mainBundle]
                                   pathForResource:normalMapName ofType: nil];
    self.normals = [GLKTextureLoader textureWithContentsOfFile: normalsNameFullPath options:textureOps error:&error];
    
    if (error != nil) {
        NSLog(@"error, %d", [error code]);
    }
    
    if (self.texture == nil) {
        NSLog(@"error, texture is nil");
    }
    
}


-(void) dealloc
{
    //loop through freeing all animations
    for (int i=0; i<numAnimations; i++) {
        //free memory allocated in animation struct
            free(animations[i]->coords);
            //free(animations[i]->animationHitmasks[j]);
        //[animations[i]->animationHitmasks release];
        free(animations[i]);
    }
    
    free(drawingInfo);
    free(animations);
    [texture release];
    [normals release];
    [hitmask release];
    
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
-(void) populateArraysWithScaleFactor: (GLfloat) scaleFactor XOffset: (GLfloat) xOffSet YOffset: (GLfloat) yOffSet screenSize: (CGRect) screenSize
{
    //because the position is going to be used with arrays for hit detection, it needs be integerlike
    self.position->origin.x = xOffSet * 100*screenSize.size.height/screenSize.size.width;
    self.position->origin.y  = yOffSet * 100*screenSize.size.width/screenSize.size.height;
    
    self.position->size.width = self.height * scaleFactor;
    self.position->size.height = self.width * scaleFactor;

    GLfloat* vertexCoords = malloc(sizeof(GLfloat) * 18);
    
    GLfloat proportion;
    GLfloat screenProportion = screenSize.size.width/screenSize.size.height;
    //this if statement ensures that the vertex coords array is at the right proportion
    if (self.width < self.height) {
        
        proportion = self.height/self.width;
        GLfloat proportionateHeight = 1.0f *scaleFactor * screenProportion;
        GLfloat proportionateWidth =  proportion *scaleFactor;
        
        vertexCoords[0] = proportionateHeight + xOffSet;
        vertexCoords[1] = proportionateWidth + yOffSet;
        vertexCoords[3] = xOffSet;
        vertexCoords[4] = yOffSet;
        vertexCoords[6] = xOffSet;
        vertexCoords[7] = proportionateWidth + yOffSet;
        vertexCoords[9] = proportionateHeight + xOffSet;
        vertexCoords[10] = proportionateWidth + yOffSet;
        vertexCoords[12] = proportionateHeight + xOffSet;
        vertexCoords[13] = yOffSet;
        vertexCoords[15] = xOffSet;
        vertexCoords[16] = yOffSet;
        
    }
    
    else {
        
        proportion = self.width/self.height;
        vertexCoords[0] = proportion*scaleFactor + xOffSet;
        vertexCoords[1] = 1.0f*scaleFactor + yOffSet;
        vertexCoords[3] = 0.0f*scaleFactor + xOffSet;
        vertexCoords[4] = 0.0f*scaleFactor + yOffSet;
        vertexCoords[6] = 0.0f*scaleFactor + xOffSet;
        vertexCoords[7] = 1.0f*scaleFactor + yOffSet;
        vertexCoords[9] = proportion*scaleFactor + xOffSet;
        vertexCoords[10] = 1.0f*scaleFactor + yOffSet;
        vertexCoords[12] = proportion*scaleFactor + xOffSet;
        vertexCoords[13] = 0.0f*scaleFactor + yOffSet;
        vertexCoords[15] = 0.0f*scaleFactor + xOffSet;
        vertexCoords[16] = 0.0f*scaleFactor + yOffSet;
        
        
    }
    
    //fill the z coords with 0s
    for (int i = 0; i <= 5 ; i++) {
        vertexCoords[i*3+2] = 0.0f;
    }
    
    glGenBuffers(1, &(self.drawingInfo->vertices));
    glBindBuffer(GL_ARRAY_BUFFER, self.drawingInfo->vertices);
    glBufferData(GL_ARRAY_BUFFER, sizeof(GLfloat)*18, vertexCoords, GL_STATIC_DRAW);
    free(vertexCoords);

}


#pragma Methods for the game engine


//test method -- delete later, move logic to character
-(void) setNextAnimation: (int) animation
{
    currentAnimation = animation;
}

/*
 moves to the next frame in the current animation
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

    drawingInfo->textureVertices = animations[currentAnimation]->coords[currentFrame];
    self.hitmask = animations[currentAnimation]->animationHitmasks[currentFrame];

    
    
    movementX += animations[currentAnimation]->xOffset;
    movementY += animations[currentAnimation]->yOffset - self.fallSpeed;
    
    
    self.drawingInfo->movementMatrix = GLKMatrix4MakeTranslation(movementX, movementY, 0);
    self.position->origin.y+= (animations[currentAnimation]->yOffset- self.fallSpeed)*100;
    self.position->origin.x+= animations[currentAnimation]->xOffset*100;
}

//if the action is invalid, undo it
-(void) undoAction
{
    movementX -= animations[currentAnimation]->xOffset;
    movementY -= animations[currentAnimation]->yOffset - self.fallSpeed;
    
    
    self.drawingInfo->movementMatrix = GLKMatrix4MakeTranslation(movementX, movementY, 0);
    self.position->origin.y-= (animations[currentAnimation]->yOffset- self.fallSpeed)*100;
    self.position->origin.x-= animations[currentAnimation]->xOffset*100;

}

-(void) applyActionEffect: (SGAction*) action
{
    self.health -= action.damage;
    movementX -= action.knockBack;
}

@end
