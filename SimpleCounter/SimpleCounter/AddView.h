//
//  AddView.h
//  SimpleCounter
//
//  Created by 陈浩贤 on 2017/2/25.
//  Copyright © 2017年 陈浩贤. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol MainVCDelegate <NSObject>
@required
-(void)removeAddView;
-(void)reloadTableView;
@end

@interface AddView : UIView

-(instancetype)initAddView;

@property id<MainVCDelegate>mainVCDelegate;

@property (weak, nonatomic) IBOutlet UITextField *titleInput;
@property (weak, nonatomic) IBOutlet UITextField *typeInput;
@property (weak, nonatomic) IBOutlet UITextField *priceInput;
@property (weak, nonatomic) IBOutlet UIPanGestureRecognizer *panGesture;

- (IBAction)didPressCancelButton:(id)sender;
- (IBAction)didPressConfirmButton:(id)sender;

- (IBAction)didTapAddView:(id)sender;
- (IBAction)handlePanGesture:(UIPanGestureRecognizer *)sender;

-(void)showWithAnimate;

@end
