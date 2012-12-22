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

-(id) initObjectNamed: (NSString*) name
{
    if (self = [super init]) {
        
        effect = [[GLKBaseEffect alloc] init];
        [self defineTextureCoords];
        [self loadTexture: [name stringByAppendingString:@"TextureData.png"]];
        [self populateArrays];
        
    }
    
    return self;

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
        NSLog(@"Texture loading error: %d", [error code]);
    }
    
    if (texture == nil) {
        NSLog(@"Error: Texture was not loaded");
        return;
    }
    
        self.effect.texture2d0.envMode = GLKTextureEnvModeReplace;
        self.effect.texture2d0.target = GLKTextureTarget2D;
        self.effect.texture2d0.name = texture.name;
        [self defineTextureCoords];
        self.effect.light0.enabled = GL_TRUE;
        self.effect.light0.diffuseColor = GLKVector4Make(1.0f, 0.4f, 0.4f, 1.0f);
        width = texture.width;
        height = texture.height;
    

}


//defines the texture coordinates to cover the whole of the image given
-(void) defineTextureCoords
{
    textureCoords = malloc(sizeof(GLfloat) * 12);
    
    textureCoords[0] = 1.0f;
    textureCoords[1] = 1.0f;
    textureCoords[2] = 0.0f;
    textureCoords[3] = 0.0f;
    textureCoords[4] = 0.0f;
    textureCoords[5] = 1.0f;
    textureCoords[6] = 1.0f;
    textureCoords[7] = 1.0f;
    textureCoords[8] = 1.0f;
    textureCoords[9] = 0.0f;
    textureCoords[10] = 0.0f;
    textureCoords[11] = 0.0f;
    
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
    free(textureCoords);
    free(vertexCoords);
    
    [texture release];
    [effect release];
    
    [super dealloc];
}

@end
