//
//  SideScrollGameLogicTests.m
//  SideScrollGameLogicTests
//
//  Created by Benjamin Pious on 2/4/13.
//  Copyright (c) 2013 Benjamin Pious. All rights reserved.
//

#import "SideScrollGameLogicTests.h"

@implementation SideScrollGameLogicTests

- (void)setUp
{
    [super setUp];
    
    // Set-up code here.
}

- (void)tearDown
{
    // Tear-down code here.
    
    [super tearDown];
}

-(void) test
{
    SGGameEngine* testEngine = [[SGGameEngine alloc] init];
    SGObjectEntity *a = [[SGObjectEntity alloc] init];
    SGObjectEntity *b = [[SGObjectEntity alloc] init];
    BOOL** mask = malloc(sizeof(BOOL*) * 4);
    
    for (int i =0; i<4; i++) {
        mask[i] = malloc(sizeof(BOOL)*4);
        mask[i][0] = YES;
        mask[i][1] = YES;
        mask[i][2] = YES;
        mask[i][3] = YES;

    }
    
    a.position = malloc(sizeof(CGRect));
    b.position = malloc(sizeof(CGRect));
    *a.position = CGRectMake(0.0, 0.0, 4.0, 4.0);
    *b.position = CGRectMake(0.0, 0.0, 4.0, 4.0);
    a.hitmask = [[SGHitMask alloc] initHitMaskWithBoolArray:mask Width:4 Height:4];
    b.hitmask = [[SGHitMask alloc] initHitMaskWithBoolArray:mask Width:4 Height:4];
    STAssertTrue([testEngine hitDetectedBetween:a and:b], @"Intersection Exists;");
    
    //--------------------------------------------------------------------------------------------------------------
    *a.position = CGRectMake(500.0, 500.0, 4.0, 4.0);
    *b.position = CGRectMake(0.0, 1.0, 4.0, 4.0);
    STAssertFalse([testEngine hitDetectedBetween:a and:b], @"Intersection Does not Exist;");
    
    //--------------------------------------------------------------------------------------------------------------
    
    BOOL** mask2 = malloc(sizeof(BOOL*) * 4);
    
    for (int i =0; i<4; i++) {
        mask2[i] = malloc(sizeof(BOOL)*4);
        mask2[i][0] = NO;
        mask2[i][1] = NO;
        mask2[i][2] = NO;
        mask2[i][3] = NO;
        
    }
 
    
    a.hitmask = [[SGHitMask alloc] initHitMaskWithBoolArray:mask2 Width:4 Height:4];
    b.hitmask = [[SGHitMask alloc] initHitMaskWithBoolArray:mask2 Width:4 Height:4];

    *a.position = CGRectMake(0.0, 0.0, 4.0, 4.0);
    *b.position = CGRectMake(0.0, 0.0, 4.0, 4.0);
    STAssertFalse([testEngine hitDetectedBetween:a and:b], @"Intersection Does not exist;");
    
    //--------------------------------------------------------------------------------------------------------------
    
    a.hitmask = [[SGHitMask alloc] initHitMaskWithBoolArray:mask Width:4 Height:4];
    b.hitmask = [[SGHitMask alloc] initHitMaskWithBoolArray:mask Width:4 Height:4];

    *a.position = CGRectMake(1.0, 1.0, 4.0, 4.0);
    *b.position = CGRectMake(0.0, 0.0, 4.0, 4.0);

    STAssertTrue([testEngine hitDetectedBetween:a and:b], @"Intersection Exists;");

    
    //--------------------------------------------------------------------------------------------------------------
    
    BOOL** mask3 = malloc(sizeof(BOOL*) * 4);
    
    for (int i =0; i<4; i++) {
        mask3[i] = malloc(sizeof(BOOL)*4);
        mask3[i][0] = NO;
        mask3[i][1] = NO;
        mask3[i][2] = NO;
        mask3[i][3] = NO;
    }
    
    
    *a.position = CGRectMake(0.0, 0.0, 4.0, 4.0);
    *b.position = CGRectMake(-3.0, -3.0, 4.0, 4.0);
    
    mask3[0][0] = YES;
    mask2[3][3] = YES;
    
    a.hitmask = [[SGHitMask alloc] initHitMaskWithBoolArray:mask3 Width:4 Height:4];
    b.hitmask = [[SGHitMask alloc] initHitMaskWithBoolArray:mask2 Width:4 Height:4];

    STAssertTrue([testEngine hitDetectedBetween:a and:b], @"Intersection Exists;");

    
    //--------------------------------------------------------------------------------------------------------------

    for (int i =0; i<4; i++) {
        mask3[i] = malloc(sizeof(BOOL)*4);
        mask3[i][0] = NO;
        mask3[i][1] = NO;
        mask3[i][2] = NO;
        mask3[i][3] = NO;
    }
    
    
    *a.position = CGRectMake(0.0, 0.0, 4.0, 4.0);
    *b.position = CGRectMake(-3.0, 0.0, 4.0, 4.0);
    
    mask3[0][0] = YES;
    mask2[3][0] = YES;
    
    a.hitmask = [[SGHitMask alloc] initHitMaskWithBoolArray:mask3 Width:4 Height:4];
    b.hitmask = [[SGHitMask alloc] initHitMaskWithBoolArray:mask2 Width:4 Height:4];
    
    STAssertTrue([testEngine hitDetectedBetween:a and:b], @"Intersection Exists;");

    
    [a release];
    [b release];
    
    for (int i=0; i<4; i++) {
        free(mask[i]);
    }
    
    free(mask);
}

@end
