//
//  SGQueue.h
//  SideScrollGame
//
//  Created by Benjamin Pious on 12/16/12.
//  Copyright (c) 2012 Benjamin Pious. All rights reserved.
//

#import <Foundation/Foundation.h>
/*
 A basic queue class.
 
 May not be needed, consider deleting. 
 */
typedef struct node  node;
struct node {
    node* next;
    void* data;

};

@interface SGQueue : NSObject
@property (assign) int length;
@property (readonly, assign) node* head;
-(void) offer: (void*) object;
-(void*) pop;

@end
