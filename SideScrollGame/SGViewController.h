//
//  SGViewController.h
//  SideScrollGame
//
//  Created by Benjamin Pious on 11/5/12.
//  Copyright (c) 2012 Benjamin Pious. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GLKit/GLKit.h>

#import "SGObjectEntity.h"
#import "SGCharacter.h"

@interface SGViewController : GLKViewController
{
    float movement;
    BOOL backwards;
    //SGObjectEntity* object;
    SGCharacter* object;
    //SGCharacter* character;
}

@end
