//
//  SGViewController.h
//  SideScrollGame
//
//  Created by Benjamin Pious on 11/5/12.
//  Copyright (c) 2012 Benjamin Pious. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GLKit/GLKit.h>

@interface SGViewController : GLKViewController
{
    GLKTextureInfo *owlTex;
    float movement;
    BOOL backwards;
}

@end
