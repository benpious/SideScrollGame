//
//  SGHitMaskManager.m
//  SideScrollGame
//
//  Created by Benjamin Pious on 1/5/13.
//  Copyright (c) 2013 Benjamin Pious. All rights reserved.
//

#import "SGHitMask.h"

@implementation SGHitMask


-(id) initHitMaskWithFileNamed: (NSString*) name Width: (int) width Height: (int) height
{
    self.width = width;
    self.height = height;
    if (self = [super init]) {
        
        NSString* maskNameFullPath = [[NSBundle mainBundle]
                                      pathForResource:name ofType: nil];
        NSData* data = [[NSFileManager defaultManager] contentsAtPath:maskNameFullPath];
        
        self.hitmask = malloc(sizeof(BOOL*)*height);
        for (int i =0; i< height; i++) {
            self.hitmask[i] = malloc(sizeof(BOOL) * width);
        }
        
        for (int i = 0; i < height; i++) {
            for (int j = 0; j<width; j++) {
                
                if (((*((int*)[data bytes])) >> (int)((i *width) + width)) % 2 == 1) {
                    self.hitmask[i][j] = YES;
                }
                
                else
                {
                    self.hitmask[i][j] = NO;
                }
            }
        }
    }
    return self;
}
-(id) initHitmaskWithHitmask: (SGHitMask*) oldHitmask Partition: (CGRect) partition
{

    self = [super init];
    if (self) {
        self.width = oldHitmask.width - partition.origin.x - partition.size.width;
        self.height = oldHitmask.height - partition.origin.y - partition.size.height;
        self.hitmask = malloc(sizeof(BOOL*) * self.height);
        
        for (int i = 0; i < self.height; i++) {
            self.hitmask[i] = malloc(sizeof(BOOL) * self.width);
            
            for (int j =0; j < self.width; j++) {
                self.hitmask[i][j] = oldHitmask.hitmask[i+(int)partition.origin.x][j+(int)partition.origin.y];
            }
        }
    }
    return self;

}

+(BOOL) collisionBetweenEquallySizedHitmasks: (SGHitMask*) a And: (SGHitMask*) b
{
    for (int i = 0; i < a.height; i++) {
        for (int j =0; j<a.height; j++) {
            if (a.hitmask[i][j] && b.hitmask[i][j]) {
                return YES;
            }
        }
    }
    
    return NO;
}

-(void) dealloc
{
    for (int i = 0; i < self.height; i++) {

        free(self.hitmask[i]);
    }
    
    free(self.hitmask);
    
    [super dealloc];
}
@end
