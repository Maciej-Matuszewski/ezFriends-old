//
//  ezChatViewController.m
//  ezFriends
//
//  Created by Maciej Matuszewski on 28.02.2015.
//  Copyright (c) 2015 Maciej Matuszewski. All rights reserved.
//

#import "ezChatViewController.h"


@interface ezChatViewController ()

@property (nonatomic, retain) NSMutableArray *messages;

@end

@implementation ezChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:self.user[@"name"]];
    
    self.senderId = [[PFUser currentUser] objectId];
    self.senderDisplayName = [PFUser currentUser][@"name"];
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 20;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    JSQMessagesCollectionViewCell *cell = (JSQMessagesCollectionViewCell *)[super collectionView:collectionView cellForItemAtIndexPath:indexPath];
    [cell.textView setTextColor:[(AppDelegate *)[[UIApplication sharedApplication] delegate] ezColor]];
    [cell setAlpha:((float)(indexPath.row+1)/(float)20)];
    return cell;
    
}

- (id<JSQMessageData>)collectionView:(JSQMessagesCollectionView *)collectionView messageDataForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return [[JSQMessage alloc] initWithSenderId:@"dfgergtre345" senderDisplayName:@"Test" date:[NSDate date] text:@"test test test test test test test test test test test test test test test test test test test test test test test test test test test test test test test test test test test test test test test test test "];
}

- (id<JSQMessageBubbleImageDataSource>)collectionView:(JSQMessagesCollectionView *)collectionView messageBubbleImageDataForItemAtIndexPath:(NSIndexPath *)indexPath
{
    //return [[[JSQMessagesBubbleImageFactory alloc] init] incomingMessagesBubbleImageWithColor:[(AppDelegate *)[[UIApplication sharedApplication] delegate] ezColor]];

    return [[[[JSQMessagesBubbleImageFactory alloc] init] initWithBubbleImage:[UIImage imageNamed:@"bubble"] capInsets:UIEdgeInsetsMake(0, 0, 0, 0)] outgoingMessagesBubbleImageWithColor:[(AppDelegate *)[[UIApplication sharedApplication] delegate] ezColor]];


}

- (id<JSQMessageAvatarImageDataSource>)collectionView:(JSQMessagesCollectionView *)collectionView avatarImageDataForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    JSQMessagesAvatarImage * factory = [JSQMessagesAvatarImageFactory avatarImageWithImage:[UIImage imageNamed:@"userDefault"] diameter:10];
    
    return factory;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
