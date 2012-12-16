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


-(id) initCharacterNamed: (NSString*) name
{
    if (self = [super init]) {
        //load texture info and any other files
        
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
        NSLog(@"error, %d", [error code]);
    }
    
    if (texture == nil) {
        NSLog(@"error, texture is nil");
    }
    
    [imageNameFullPath release];
    
    [texture retain];
    
}

@end
