//
//  SGEntityProtocol.h
//  SideScrollGame
//
//  Created by Benjamin Pious on 12/15/12.
//  Copyright (c) 2012 Benjamin Pious. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>
#import "SGAction.h"

typedef struct {
    GLuint vertices;
    GLuint textureVertices;
    GLuint normalMap;
    //NSString* shaderName;
    GLKMatrix4 movementMatrix;
} drawInfo;

@protocol SGEntityProtocol <NSObject>
@property (assign) GLfloat* textureCoords;
@property (assign) GLfloat* vertexCoords;
@property (retain) GLKTextureInfo *texture;
@property (retain) GLKTextureInfo *normals;
@property (assign) BOOL isFalling;
@property (assign) GLfloat fallSpeed;
@property (assign) GLfloat width;
@property (assign) GLfloat height;
@property (assign) drawInfo* drawingInfo;

-(void) applyActionEffect: (SGAction*) action;

@end
