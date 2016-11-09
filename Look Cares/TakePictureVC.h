//
//  TakePictureVC.h
//  Look Cares
//
//  Created by Fox Man on 06/11/16.
//  Copyright © 2016 The Lookup Company. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TakePictureVC : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate>


@property (weak, nonatomic) IBOutlet UIImageView *imgPhoto;
- (IBAction)onBtnTakePicture:(id)sender;
- (IBAction)onBtnDone:(id)sender;
@end
