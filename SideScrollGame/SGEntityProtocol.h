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

/*
 Provides all the information needed for OpenGL ES 
 */
typedef struct {
    GLuint vertices;
    GLuint textureVertices;
    GLuint normalMap;
    //NSString* shaderName;
    GLKMatrix4 movementMatrix;
} drawInfo;

/*
 An SGEntity is a sprite which is drawn in an opengl context. 
 It has basic interactivity with the environment, such as the ability to fall,
 and the ability to change based on the actions of other entities
 */
@protocol SGEntityProtocol <NSObject>
@property (retain) GLKTextureInfo *texture;
@property (retain) GLKTextureInfo *normals;
@property (assign) BOOL isFalling;
@property (assign) GLfloat fallSpeed;
@property (assign) GLfloat width;
@property (assign) GLfloat height;
@property (assign) drawInfo* drawingInfo;

-(void) applyActionEffect: (SGAction*) action;

@end
