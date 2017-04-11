//
//  ViewController.m
//  OCRDemo
//
//  Created by gongzhen on 3/20/17.
//  Copyright © 2017 gongzhen. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate, G8TesseractDelegate>{

}

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIButton *selectButton;
@property (weak, nonatomic) IBOutlet UILabel *textLabel;

@property (strong, nonatomic) G8Tesseract *tesseract;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

}

- (void)viewWillAppear:(BOOL)animated {
    if (_imageView.image) {
        [super viewWillAppear:animated];
        self.tesseract = [[G8Tesseract alloc] initWithLanguage:@"eng"];
//        self.tesseract.engineMode = G8OCREngineModeTesseractCubeCombined;
//        self.tesseract.pageSegmentationMode = G8PageSegmentationModeAuto;
        self.tesseract.delegate = self;
//        self.tesseract.charWhitelist = @"0123456789";
        self.tesseract.image = [_imageView.image g8_blackAndWhite];
        self.tesseract.rect = CGRectMake(20, 20, 100, 30);
        self.tesseract.maximumRecognitionTime = 2.0;
        // Start the recognition
        NSLog(@"%d", [self.tesseract recognize]);
        
        // Retrieve the recognized text
        NSLog(@"output:%@", [self.tesseract recognizedText]);
        NSArray *characterBoxes = [self.tesseract recognizedBlocksByIteratorLevel:G8PageIteratorLevelSymbol];
        NSLog(@"characterBoxes:%@", characterBoxes);
    }
}

- (IBAction)convertImageButtonClicked:(id)sender {
    self.tesseract.image = _imageView.image;
    self.tesseract.maximumRecognitionTime = 2.0;
    [self.tesseract recognize];
    NSLog(@"%@", [self.tesseract recognizedText]);
    _textLabel.text = [self.tesseract recognizedText];
}



- (IBAction)selectImageButtonClicked:(id)sender {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil
                                                                   message:nil
                                                            preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *openCamrea = [UIAlertAction actionWithTitle:@"Open camrea"
                                                         style:UIAlertActionStyleDefault
                                                       handler:^(UIAlertAction * _Nonnull action) {
                                                           if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                                                               UIImagePickerController *picker = [[UIImagePickerController alloc] init];
                                                               picker.delegate = self;
                                                               picker.allowsEditing = YES;
                                                               picker.sourceType = UIImagePickerControllerSourceTypeCamera;
                                                               
                                                               //Create camera overlay
                                                               CGRect f = picker.view.bounds;
                                                               f.size.height -= picker.navigationBar.bounds.size.height;
                                                               CGFloat barHeight = (f.size.height - f.size.width);
                                                               UIGraphicsBeginImageContext(f.size);
//                                                               [[UIColor colorWithWhite:0 alpha:.5] set];
                                                               [[UIColor blueColor] set];
                                                               
                                                               UIRectFillUsingBlendMode(CGRectMake(0, 0, f.size.width, barHeight), kCGBlendModeNormal);
                                                               UIRectFillUsingBlendMode(CGRectMake(0, f.size.height - barHeight, f.size.width, barHeight), kCGBlendModeNormal);
                                                               UIImage *overlayImage = UIGraphicsGetImageFromCurrentImageContext();
                                                               UIGraphicsEndImageContext();
                                                               UIImageView *overlayIV = [[UIImageView alloc] initWithFrame:f];
                                                               overlayIV.image = overlayImage;
                                                               [picker.cameraOverlayView addSubview:overlayIV];
                                                               
                                                               //end
                                                               
                                                               [self presentViewController:picker animated:YES completion:NULL];
                                                           }
                                                       }];

    UIAlertAction *openGallery = [UIAlertAction actionWithTitle:@"Open gallery"
                                                         style:UIAlertActionStyleDefault
                                                       handler:^(UIAlertAction * _Nonnull action) {
                                                           if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
                                                               UIImagePickerController *picker = [[UIImagePickerController alloc] init];
                                                               picker.delegate = self;
                                                               picker.allowsEditing = YES;
                                                               picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                                                               [self presentViewController:picker animated:YES completion:NULL];
                                                           }
                                                       }];
    [alert addAction:openCamrea];
    [alert addAction:openGallery];
    [alert addAction:[UIAlertAction actionWithTitle:@"Cancel"
                                              style:UIAlertActionStyleCancel
                                            handler:^(UIAlertAction * _Nonnull action) {
                                                
                                            }]];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - UIImagePickerControllerDelegate
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    if (picker.sourceType == UIImagePickerControllerSourceTypeCamera) {
        UIImageWriteToSavedPhotosAlbum([info objectForKey:UIImagePickerControllerOriginalImage], self, nil, nil);
        UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
        self.imageView.image = image;
        [picker dismissViewControllerAnimated:YES completion:NULL];        
    }
//    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
//    self.imageView.image = chosenImage;
//    [picker dismissViewControllerAnimated:YES completion:NULL];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:NULL];    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
