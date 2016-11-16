//
//  DetailViewController.h
//  RealmDemo
//
//  Created by taehoon.jung on 2016. 11. 13..
//  Copyright © 2016년 thlife. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Dog;
@interface DetailViewController : UIViewController

@property (strong, nonatomic) Dog *detailItem;
@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;

@end

