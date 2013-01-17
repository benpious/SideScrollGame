//
//  SGMainCharacter.h
//  SideScrollGame
//
//  Created by Benjamin Pious on 1/9/13.
//  Copyright (c) 2013 Benjamin Pious. All rights reserved.
//

#import "SGCharacter.h"
#import "Playable.h"


@interface SGMainCharacter : SGCharacter<Playable>
@property (retain) NSArray* inputsToDisplay;
@end
