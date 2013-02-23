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
        
        self.hitmask = malloc(sizeof(BOOL*) * width);
        for (int i = 0; i < width; i++) {
            self.hitmask[i] = malloc(sizeof(BOOL) * height);
        }
        
        for (int i = 0; i < width; i++) {
            for (int j = 0; j < height; j++) {
                
                if (((uint8_t*)[data bytes])[(width * j + i)/8] & (1 << (i%8))) {
                    self.hitmask[i][j] = YES;
                }
                
                else {
                    
                    self.hitmask[i][j] = NO;
                }
            }
        }
        
    }
    return self;
}

//should take the origin of the old hitmask as well
-(id) initHitmaskWithHitmask: (SGHitMask*) oldHitmask Partition: (CGRect) partition OldHitMaskOrigin: (CGPoint) hitMaskOrigin
{

    if (self = [super init]) {
        
        self.width = partition.size.width;
        self.height = partition.size.height;
        self.hitmask = malloc(sizeof(BOOL*) * self.width);
        
        for (int i = 0; i < self.width; i++) {
            
            self.hitmask[i] = malloc(sizeof(BOOL) * self.height);
            
            for (int j = 0; j < self.height; j++) {
                
                self.hitmask[i][j] = oldHitmask.hitmask[i + (int)(partition.origin.x - hitMaskOrigin.x)][j + (int)(partition.origin.y -  hitMaskOrigin.y)];
                
            }
        }
    }
    return self;

}

-(id) initHitMaskWithBoolArray:(BOOL **)oldHitmask Width:(int)width Height:(int)height {
    
    if (self = [super init]) {
        
        self.width = width;
        self.height = height;
        
        self.hitmask = malloc(sizeof(BOOL*) * width);
        
        for (int i = 0 ; i < width; i++) {
            self.hitmask[i] = malloc(sizeof(BOOL) * height);
            
            for (int j=0; j<height; j++) {
                self.hitmask[i][j] = oldHitmask[i][j];
            }
        }
    }
    
    return self;
}

+(BOOL) collisionBetweenEquallySizedHitmasks: (SGHitMask*) a And: (SGHitMask*) b
{
    for (int i = 0; i < a.width; i++) {
        for (int j = 0; j < a.height; j++) {
            if (a.hitmask[i][j] && b.hitmask[i][j]) {
                return YES;
            }
        }
    }
    
    return NO;
}

-(void) dealloc
{
    for (int i = 0; i < self.width; i++) {

        free(self.hitmask[i]);
    }
    
    free(self.hitmask);
    [super dealloc];
}

@end
