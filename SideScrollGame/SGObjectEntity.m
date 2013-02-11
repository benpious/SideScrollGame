//
//  SGObjectEntity.m
//  SideScrollGame
//
//  Created by Benjamin Pious on 12/15/12.
//  Copyright (c) 2012 Benjamin Pious. All rights reserved.
//

#import "SGObjectEntity.h"

@implementation SGObjectEntity
@synthesize vertexCoords;
@synthesize textureCoords;
@synthesize effect;
@synthesize texture;
@synthesize fallSpeed;
@synthesize isFalling;
@synthesize hitmask;
@synthesize height;
@synthesize width;
@synthesize position;

-(id) initObjectNamed: (NSString*) name withScreenSize:(CGRect)screenSize
{
    if (self = [super init]) {
        
        self.effect = [[GLKBaseEffect alloc] init];
        self.position = malloc(sizeof(CGRect));
        *self.position = CGRectMake(0.0f, 0.0f, 0.0f, 0.0f);
        [self defineTextureCoords];
        [self loadTexture: [name stringByAppendingString:@"TextureData.png"]];
        [self loadScaleAndOffsetInfo:[name stringByAppendingString:@"ScaleOffset"] withScreenSize: (CGRect) screenSize];
        fallSpeed = 0.0f;
        isFalling = NO;
        //self.hitmask = [[SGHitMask alloc] initHitMaskWithFileNamed:[name stringByAppendingString: @"HitMask.hmk"] Width:self.width Height:self.height];
        
        // test code delete later
        
        

    }
    
    return self;

}

-(void) loadTexture: (NSString*) imageName
{
    NSError *error = nil;
    NSDictionary* textureOps = @{GLKTextureLoaderApplyPremultiplication : @NO, GLKTextureLoaderGenerateMipmaps : @NO, GLKTextureLoaderOriginBottomLeft : @YES};
    NSString* imageNameFullPath = [[NSBundle mainBundle]
                                   pathForResource:imageName ofType: nil];
    self.texture = [GLKTextureLoader textureWithContentsOfFile: imageNameFullPath options:textureOps error:&error];
    
    if (error != nil) {
        NSLog(@"Texture loading error: %d", [error code]);
    }
    
    if (self.texture == nil) {
        NSLog(@"Error: Texture was not loaded");
        return;
    }
    
    self.effect.texture2d0.envMode = GLKTextureEnvModeReplace;
    self.effect.texture2d0.target = GLKTextureTarget2D;
    self.effect.texture2d0.name = texture.name;
    self.effect.light0.enabled = GL_TRUE;
    self.effect.light0.diffuseColor = GLKVector4Make(1.0f, 0.4f, 0.4f, 1.0f);
    self.width = self.texture.width;
    self.height = self.texture.height;    
    
}



//defines the texture coordinates to cover the whole of the image given
-(void) defineTextureCoords
{
    self.textureCoords = malloc(sizeof(GLfloat) * 12);
    
    self.textureCoords[0] = 1.0f;
    self.textureCoords[1] = 1.0f;
    self.textureCoords[2] = 0.0f;
    self.textureCoords[3] = 0.0f;
    self.textureCoords[4] = 0.0f;
    self.textureCoords[5] = 1.0f;
    self.textureCoords[6] = 1.0f;
    self.textureCoords[7] = 1.0f;
    self.textureCoords[8] = 1.0f;
    self.textureCoords[9] = 0.0f;
    self.textureCoords[10] = 0.0f;
    self.textureCoords[11] = 0.0f;
    
}

-(void) populateArraysWithScaleFactor: (GLfloat) scaleFactor xOffset: (GLfloat) xOffset yOffset: (GLfloat) yOffset withScreenSize: (CGRect) screenSize
{
    
    self.vertexCoords = malloc(sizeof(GLfloat) * 18);
    self.position->origin.x = xOffset * 100;
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
        
        self.vertexCoords[0] = proportionateHeight + xOffset;
        self.vertexCoords[1] = proportionateWidth + yOffset;
        self.vertexCoords[3] = xOffset;
        self.vertexCoords[4] = yOffset;
        self.vertexCoords[6] = xOffset;
        self.vertexCoords[7] = proportionateWidth + yOffset;
        self.vertexCoords[9] = proportionateHeight + xOffset;
        self.vertexCoords[10] = proportionateWidth + yOffset;
        self.vertexCoords[12] = proportionateHeight + xOffset;
        self.vertexCoords[13] = yOffset;
        self.vertexCoords[15] = xOffset;
        self.vertexCoords[16] = yOffset;
    }
    
    else {
        
        proportion = self.width/self.height;
        self.vertexCoords[0] = proportion*scaleFactor + xOffset;
        self.vertexCoords[1] = 1.0f*scaleFactor + yOffset;
        self.vertexCoords[3] = 0.0f*scaleFactor + xOffset;
        self.vertexCoords[4] = 0.0f*scaleFactor + yOffset;
        self.vertexCoords[6] = 0.0f*scaleFactor + xOffset;
        self.vertexCoords[7] = 1.0f*scaleFactor + yOffset;
        self.vertexCoords[9] = proportion*scaleFactor + xOffset;
        self.vertexCoords[10] = 1.0f*scaleFactor + yOffset;
        self.vertexCoords[12] = proportion*scaleFactor + xOffset;
        self.vertexCoords[13] = 0.0f*scaleFactor + yOffset;
        self.vertexCoords[15] = 0.0f*scaleFactor + xOffset;
        self.vertexCoords[16] = 0.0f*scaleFactor + yOffset;
        
        
    }
    
    //fill the z coords with 0s
    for (int i = 0; i <= 5 ; i++) {
        self.vertexCoords[i*3+2] = 0.0f;
    }
    
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
    free(textureCoords);
    free(vertexCoords);
    
    [texture release];
    [effect release];
    
    [hitmask release];
    
    [super dealloc];
}

//Does nothing by default: Subclasses which need to react to actions in specific ways may implement this method.
-(void) applyActionEffect: (SGAction*) action
{
    
}


@end
