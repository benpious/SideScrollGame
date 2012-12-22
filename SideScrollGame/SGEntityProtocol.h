//
//  SGEntityProtocol.h
//  SideScrollGame
//
//  Created by Benjamin Pious on 12/15/12.
//  Copyright (c) 2012 Benjamin Pious. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>

@protocol SGEntityProtocol <NSObject>
@property (retain) GLKBaseEffect* effect;
@property (assign) GLfloat* textureCoords;
@property (assign) GLfloat* vertexCoords;
@property (retain) GLKTextureInfo *texture;

@end
