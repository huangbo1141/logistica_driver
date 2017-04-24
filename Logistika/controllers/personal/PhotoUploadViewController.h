//
//  PhotoUploadViewController.h
//  Logistika
//
//  Created by BoHuang on 4/20/17.
//  Copyright © 2017 BoHuang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "SelectImageCell.h"
#import "ELCImagePickerHeader.h"
#import "ActionDelegate.h"

@interface PhotoUploadViewController : UIViewController<AVCaptureMetadataOutputObjectsDelegate,ELCImagePickerControllerDelegate, UINavigationControllerDelegate, ActionDelegate>
@property (weak, nonatomic) IBOutlet UISegmentedControl *segControl;
@property (weak, nonatomic) IBOutlet SelectImageCell *imgCell1;
@property (weak, nonatomic) IBOutlet SelectImageCell *imgCell2;
@property (weak, nonatomic) IBOutlet SelectImageCell *imgCell3;

@property (weak, nonatomic) IBOutlet UIView *viewPreview;
@property (nonatomic, assign) int limit;
@end
