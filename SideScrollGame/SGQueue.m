//
//  SGQueue.m
//  SideScrollGame
//
//  Created by Benjamin Pious on 12/16/12.
//  Copyright (c) 2012 Benjamin Pious. All rights reserved.
//

#import "SGQueue.h"

@implementation SGQueue
@synthesize head;
@synthesize length;

-(id) init
{
    if (self = [super init]) {
        length=0;
    }
    return self;
}

-(void) offer: (void*) object
{
    node* newHead = malloc(sizeof(node));
    newHead->next = head;
    //this DOES NOT take ownership of the object -- it must be freed manually
    newHead->data = object;
    head = newHead;
}
-(void*) pop
{
    if (length ==0) {
        return nil;
    }
    length--;
    void* toReturn = head->data;
    node *oldHead = head;
    head = head->next;
    free(oldHead);
    return toReturn;
}

/*
 this method will leak -- need to free memory pointed to for each node
 */
-(void) dealloc
{
    for (int i =0; i<length; i++) {
        [self pop];
    }
    
    [super dealloc];
}

@end
