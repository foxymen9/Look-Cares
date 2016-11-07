//
//  TakePictureVC.h
//  Look Cares
//
//  Created by Bendt Jensen on 06/11/16.
//  Copyright © 2016 The Lookup Company. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TakePictureVC : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

- (IBAction)onBtnOpenCamera:(id)sender;
@property (weak, nonatomic) IBOutlet UIImageView *imgPhoto;
@end
