//
//  ezChatViewController.m
//  ezFriends
//
//  Created by Maciej Matuszewski on 28.02.2015.
//  Copyright (c) 2015 Maciej Matuszewski. All rights reserved.
//

#import "ezChatViewController.h"


@interface ezChatViewController ()

@property (nonatomic, retain) NSArray *messages;

@property (nonatomic, retain) JSQMessagesBubbleImage *incomingBubble;
@property (nonatomic, retain) JSQMessagesBubbleImage *outgoingBubble;
@property (nonatomic, retain) JSQMessagesAvatarImage *incomingAvatar;
@property (nonatomic, retain) JSQMessagesAvatarImage *outgoingAvatar;

@end

@implementation ezChatViewController

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:self.user[@"name"]];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reciveMessage) name:SINCH_MESSAGE_RECIEVED object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sendMessage) name:SINCH_MESSAGE_SENT object:nil];
 
    //[(AppDelegate *)[[UIApplication sharedApplication] delegate] sendTextMessage:@"test" toRecipient:@"RAHamKkloj"];
    
    self.messages = [(AppDelegate *)[[UIApplication sharedApplication] delegate] reciveMessagesForUser:self.user.objectId];
    
    self.senderId = [[PFUser currentUser] objectId];
    self.senderDisplayName = [PFUser currentUser][@"name"];
    
    [self setIncomingBubble:[[[[JSQMessagesBubbleImageFactory alloc] init] initWithBubbleImage:[UIImage imageNamed:@"bubble"] capInsets:UIEdgeInsetsMake(0, 0, 0, 0)] incomingMessagesBubbleImageWithColor:[(AppDelegate *)[[UIApplication sharedApplication] delegate] ezColor]]];
    [self setOutgoingBubble:[[[[JSQMessagesBubbleImageFactory alloc] init] initWithBubbleImage:[UIImage imageNamed:@"bubble"] capInsets:UIEdgeInsetsMake(0, 0, 0, 0)] outgoingMessagesBubbleImageWithColor:[UIColor darkGrayColor]]];
    [self setIncomingAvatar:[JSQMessagesAvatarImageFactory avatarImageWithPlaceholder:[UIImage imageNamed:@"userDefault"] diameter:100]];
    [self setOutgoingAvatar:[JSQMessagesAvatarImageFactory avatarImageWithPlaceholder:[UIImage imageNamed:@"userDefault"] diameter:100]];
    
    [self.user[@"photo"] getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error) {
        if (!error) {
            [self setIncomingAvatar:[JSQMessagesAvatarImageFactory avatarImageWithImage:[UIImage imageWithData:imageData] diameter:100]];
            [self.collectionView reloadData];
        }
    }];
    [[PFUser currentUser][@"photo"] getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error) {
        if (!error) {
            [self setOutgoingAvatar:[JSQMessagesAvatarImageFactory avatarImageWithImage:[UIImage imageWithData:imageData] diameter:100]];
            [self.collectionView reloadData];
        }
    }];
    
    
}

#pragma mark - Database

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.messages.count;
}

#pragma mark - CellContent

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    NSDictionary *message = [self.messages objectAtIndex:indexPath.row];
    JSQMessagesCollectionViewCell *cell = (JSQMessagesCollectionViewCell *)[super collectionView:collectionView cellForItemAtIndexPath:indexPath];
    
    if ([message[@"senderID"] isEqualToString:[[PFUser currentUser] objectId]]) {
        [cell.textView setTextColor:[UIColor darkGrayColor]];
    }else{
        [cell.textView setTextColor:[(AppDelegate *)[[UIApplication sharedApplication] delegate] ezColor]];
    }
    
    [cell setAlpha:(float)(1440-[[[[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar] components:NSMinuteCalendarUnit fromDate:message[@"date"] toDate:[NSDate date] options:0] minute])/1440];
    
    cell.textView.linkTextAttributes = @{ NSForegroundColorAttributeName : cell.textView.textColor,
                                          NSUnderlineStyleAttributeName : @(NSUnderlineStyleSingle | NSUnderlinePatternSolid) };
    return cell;
    
}

- (NSAttributedString *)collectionView:(JSQMessagesCollectionView *)collectionView attributedTextForCellTopLabelAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *message = [self.messages objectAtIndex:indexPath.row];
    if (indexPath.row == 0) return [[JSQMessagesTimestampFormatter sharedFormatter] attributedTimestampForDate:message[@"date"]];
    NSDictionary *lastMessage = [self.messages objectAtIndex:indexPath.row-1];
    if([[[[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar] components:NSMinuteCalendarUnit fromDate:lastMessage[@"date"] toDate:message[@"date"] options:0] minute] > 29)return [[JSQMessagesTimestampFormatter sharedFormatter] attributedTimestampForDate:message[@"date"]];
    return nil;
}

- (id<JSQMessageData>)collectionView:(JSQMessagesCollectionView *)collectionView messageDataForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *message = [self.messages objectAtIndex:indexPath.row];
    
    return [[JSQMessage alloc] initWithSenderId:message[@"senderID"] senderDisplayName:[message[@"senderID"] isEqualToString:[[PFUser currentUser] objectId]]?[PFUser currentUser][@"name"]:self.user[@"name"] date:message[@"date"] text:message[@"text"]];
}

- (id<JSQMessageBubbleImageDataSource>)collectionView:(JSQMessagesCollectionView *)collectionView messageBubbleImageDataForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return [[self.messages objectAtIndex:indexPath.row][@"senderID"] isEqualToString:[[PFUser currentUser] objectId]]?self.outgoingBubble:self.incomingBubble;
}

- (id<JSQMessageAvatarImageDataSource>)collectionView:(JSQMessagesCollectionView *)collectionView avatarImageDataForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return [[self.messages objectAtIndex:indexPath.row][@"senderID"] isEqualToString:[[PFUser currentUser] objectId]]?self.outgoingAvatar:self.incomingAvatar;
}

#pragma mark - Layout

- (CGFloat)collectionView:(JSQMessagesCollectionView *)collectionView
                   layout:(JSQMessagesCollectionViewFlowLayout *)collectionViewLayout heightForCellTopLabelAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *message = [self.messages objectAtIndex:indexPath.row];
    if (indexPath.row == 0) return kJSQMessagesCollectionViewCellLabelHeightDefault;
    NSDictionary *lastMessage = [self.messages objectAtIndex:indexPath.row-1];
    if([[[[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar] components:NSMinuteCalendarUnit fromDate:lastMessage[@"date"] toDate:message[@"date"] options:0] minute] > 29)return kJSQMessagesCollectionViewCellLabelHeightDefault;
    return 0.0f;
    
}


#pragma mark - recivingMessage
- (void)reciveMessage{
    self.messages = [(AppDelegate *)[[UIApplication sharedApplication] delegate] reciveMessagesForUser:self.user.objectId];
    [self.collectionView reloadData];
    [self scrollToBottomAnimated:YES];
}

#pragma mark - sendingMessage

- (void)didPressSendButton:(UIButton *)button
           withMessageText:(NSString *)text
                  senderId:(NSString *)senderId
         senderDisplayName:(NSString *)senderDisplayName
                      date:(NSDate *)date
{
    
    [(AppDelegate *)[[UIApplication sharedApplication] delegate] sendTextMessage:text toRecipient:self.user.objectId];
}

- (void)sendMessage{
    [JSQSystemSoundPlayer jsq_playMessageSentSound];
    self.messages = [(AppDelegate *)[[UIApplication sharedApplication] delegate] reciveMessagesForUser:self.user.objectId];
    [self finishSendingMessageAnimated:YES];
}

-(void)didPressAccessoryButton:(UIButton *)sender{
    
}

@end
