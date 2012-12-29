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

-(void) offer: (id) object
{
    node* newHead = malloc(sizeof(node));
    newHead->next = head;
    newHead->data = object;
    [newHead->data retain];
    head = newHead;
}
-(id) pop
{
    if (length ==0) {
        return nil;
    }
    length--;
    id toReturn = head->data;
    node *oldHead = head;
    head = head->next;
    free(oldHead);
    return toReturn;
}

-(void) dealloc
{
    for (int i =0; i<length; i++) {
        [[self pop] release];
    }
    
    [super dealloc];
}

@end
