//
//  SGObjectEntity.m
//  SideScrollGame
//
//  Created by Benjamin Pious on 12/15/12.
//  Copyright (c) 2012 Benjamin Pious. All rights reserved.
//

#import "SGObjectEntity.h"

@implementation SGObjectEntity
@synthesize texture;
@synthesize fallSpeed;
@synthesize isFalling;
@synthesize hitmask;
@synthesize height;
@synthesize width;
@synthesize position;
@synthesize drawingInfo;
@synthesize normals;

-(id) initObjectNamed: (NSString*) name withScreenSize:(CGRect)screenSize
{
    if (self = [super init]) {
        self.position = malloc(sizeof(CGRect));
        *self.position = CGRectMake(0.0f, 0.0f, 0.0f, 0.0f);
        self.drawingInfo =  malloc(sizeof(drawInfo));
        //fill in the movement matrix
        self.drawingInfo->movementMatrix = GLKMatrix4MakeTranslation(0, 0, 0);
        [self defineTextureCoords];
        [self loadTexture: [name stringByAppendingString:@"TextureData.png"]];
        [self loadNormalMap:[name stringByAppendingString:@"NormalData.png"]];
        [self loadScaleAndOffsetInfo:[name stringByAppendingString:@"ScaleOffset"] withScreenSize: (CGRect) screenSize];
        fallSpeed = 0.0f;
        isFalling = NO;
        //self.hitmask = [[SGHitMask alloc] initHitMaskWithFileNamed:[name stringByAppendingString: @"HitMask.hmk"] Width:self.width Height:self.height];
        
        //test code delete later
        BOOL** hitmaskarray = malloc(sizeof(BOOL*) * self.position->size.width);
        for (int i = 0; i<self.position->size.width; i++) {
            hitmaskarray[i] = malloc(sizeof(BOOL) * self.position->size.height);
            for (int j =0; j<self.position->size.height; j++) {
                hitmaskarray[i][j] = NO;
            }
        }
        
        for (int i = 0; i < self.position->size.width; i++) {
            
            hitmaskarray[i][0] = YES;
        }
        
        self.hitmask = [[SGHitMask alloc] initHitMaskWithBoolArray:hitmaskarray Width:self.position->size.width Height:self.position->size.height];
        
        for (int i = 0; i < self.position->size.width; i++) {
            free(hitmaskarray[i]);
        }
        
        free(hitmaskarray);

    }
    
    //end test code
    
    return self;

}

-(void) loadTexture: (NSString*) imageName
{
    /*if there is a glerror reported when this method enters it will fail to load the texture
     therefore, get the error just so that opengl won't fail -- obviously this isn't a great solution*/
    glGetError();
    //end test
    
    NSError *error = nil;
    NSDictionary* textureOps = @{GLKTextureLoaderApplyPremultiplication : @NO, GLKTextureLoaderGenerateMipmaps : @NO, GLKTextureLoaderOriginBottomLeft : @YES};
    NSString* imageNameFullPath = [[NSBundle mainBundle]
                                   pathForResource:imageName ofType: nil];
    self.texture = [GLKTextureLoader textureWithContentsOfFile: imageNameFullPath options:textureOps error:&error];
    
    if (error != nil) {
        NSLog(@"%@", imageName);
        NSLog(@"Object Texture loading error: %d", [error code]);
    }
    
    if (self.texture == nil) {
        NSLog(@"Error: Object Texture was not loaded");
        return;
    }
    
    self.width = self.texture.width;
    self.height = self.texture.height;    
    
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


//defines the texture coordinates to cover the whole of the image given
-(void) defineTextureCoords
{

    GLfloat* textureCoordsArray = malloc(sizeof(GLfloat) * 12);
    
    textureCoordsArray[0] = 1.0f;
    textureCoordsArray[1] = 1.0f;
    textureCoordsArray[2] = 0.0f;
    textureCoordsArray[3] = 0.0f;
    textureCoordsArray[4] = 0.0f;
    textureCoordsArray[5] = 1.0f;
    textureCoordsArray[6] = 1.0f;
    textureCoordsArray[7] = 1.0f;
    textureCoordsArray[8] = 1.0f;
    textureCoordsArray[9] = 0.0f;
    textureCoordsArray[10] = 0.0f;
    textureCoordsArray[11] = 0.0f;
    
    glGenBuffers(1, &(self.drawingInfo->textureVertices));
    glBindBuffer(GL_ARRAY_BUFFER, self.drawingInfo->textureVertices);
    glBufferData(GL_ARRAY_BUFFER, sizeof(GLfloat)*12, textureCoordsArray, GL_STATIC_DRAW);
    free(textureCoordsArray);
    
}

-(void) populateArraysWithScaleFactor: (GLfloat) scaleFactor xOffset: (GLfloat) xOffset yOffset: (GLfloat) yOffset withScreenSize: (CGRect) screenSize
{
    
    GLfloat* vertexCoords = malloc(sizeof(GLfloat) * 18);
    self.position->origin.x = xOffset * 100*screenSize.size.height/screenSize.size.width;
    self.position->origin.y = yOffset * 100;
	self.position->size.width = self.width * scaleFactor;
    self.position->size.height = self.height * scaleFactor;
    
    GLfloat proportion;
    GLfloat screenProportion = screenSize.size.width/screenSize.size.height;
    //this test and if statement ensure that the vertex coords array is at the right proportion
    if (self.width < self.height) {
        
        proportion = self.height/self.width;
        GLfloat proportionateHeight = 1.0*scaleFactor * screenProportion;
        GLfloat proportionateWidth = proportion*scaleFactor;
        
        vertexCoords[0] = proportionateHeight + xOffset;
        vertexCoords[1] = proportionateWidth + yOffset;
        vertexCoords[3] = xOffset;
        vertexCoords[4] = yOffset;
        vertexCoords[6] = xOffset;
        vertexCoords[7] = proportionateWidth + yOffset;
        vertexCoords[9] = proportionateHeight + xOffset;
        vertexCoords[10] = proportionateWidth + yOffset;
        vertexCoords[12] = proportionateHeight + xOffset;
        vertexCoords[13] = yOffset;
        vertexCoords[15] = xOffset;
        vertexCoords[16] = yOffset;
    }
    
    else {
        
        proportion = self.width/self.height;
        vertexCoords[0] = proportion*scaleFactor + xOffset;
        vertexCoords[1] = 1.0f*scaleFactor + yOffset;
        vertexCoords[3] = 0.0f*scaleFactor + xOffset;
        vertexCoords[4] = 0.0f*scaleFactor + yOffset;
        vertexCoords[6] = 0.0f*scaleFactor + xOffset;
        vertexCoords[7] = 1.0f*scaleFactor + yOffset;
        vertexCoords[9] = proportion*scaleFactor + xOffset;
        vertexCoords[10] = 1.0f*scaleFactor + yOffset;
        vertexCoords[12] = proportion*scaleFactor + xOffset;
        vertexCoords[13] = 0.0f*scaleFactor + yOffset;
        vertexCoords[15] = 0.0f*scaleFactor + xOffset;
        vertexCoords[16] = 0.0f*scaleFactor + yOffset;
        
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

-(void) loadScaleAndOffsetInfo: (NSString*) plistName withScreenSize: (CGRect) screenSize
{
    NSPropertyListFormat format;
    NSString* error = nil;
    NSString* path = [[NSBundle mainBundle] pathForResource:plistName ofType:@".plist"];
    NSData* plistXML = [[NSFileManager defaultManager] contentsAtPath:path];
    NSArray* infoArray = (NSArray*)[NSPropertyListSerialization propertyListWithData:plistXML options:NSPropertyListImmutable format:&format error:nil];

    //handle the error
    
    if (error != nil) {
        NSLog(@"error reading plist");
    }
    
    [self populateArraysWithScaleFactor:[[infoArray objectAtIndex:0] floatValue] xOffset:[[infoArray objectAtIndex:1] floatValue] yOffset:[[infoArray objectAtIndex:2] floatValue] withScreenSize: screenSize];
    
}


-(void) dealloc
{
        
    [texture release];
    
    [hitmask release];
    
    [super dealloc];
}

//Does nothing by default: Subclasses which need to react to actions in specific ways may implement this method.
-(void) applyActionEffect: (SGAction*) action
{
    
}


@end
