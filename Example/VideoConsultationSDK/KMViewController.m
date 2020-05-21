//
//  KMViewController.m
//  VideoConsultationSDK
//
//  Created by zhenlove on 05/18/2020.
//  Copyright (c) 2020 zhenlove. All rights reserved.
//

#import "KMViewController.h"
#import <ZLPhotoBrowser/ZLPhotoBrowser.h>
#import <MBProgressHUD/MBProgressHUD.h>
@import VideoConsultation;
@interface KMViewController ()<UIDocumentInteractionControllerDelegate>
@property (nonatomic, strong) VideoConsultationManager *manager;
@property (nonatomic, strong) MBProgressHUD *hud;;
@property (nonatomic, strong) Member *member;
@property (nonatomic, strong) DoctorInfo * doctor;
@property (nonatomic, strong) MedicalInfo * medicalInfo;
@property (nonatomic, strong) VCParam * param;
@end

@implementation KMViewController
-(VideoConsultationManager *)manager {
    if (!_manager) {
        _manager = [[VideoConsultationManager alloc]init];
    }
    return _manager;
}

-(Member *)member {
    if (!_member) {
        _member = [[Member alloc]init];
        _member.phone = @"13760291826";
        _member.birthday = @"2001-01-09";
        _member.name = @"林祥";
        _member.gender = @"男";
        _member.allergicRemark = @"花粉过敏,等等";
    }
    return _member;
}
-(DoctorInfo *)doctor {
    if (!_doctor) {
        _doctor = [[DoctorInfo alloc]init];
//        _doctor.doctorId = @"928e4ffd5873478ba1dabe3e483335a1";
//        _doctor.doctorHeadUrl = @"https://tstore2.kmwlyy.com:8015/images/854874cb0ca5b3b12025351f37e02472.jpg";
//        _doctor.doctorName = @"康美云";
        
        _doctor.doctorId = @"78ee0381bbb541aba41fbc2ecb4566ba";
        _doctor.doctorHeadUrl = @"https://tstore2.kmwlyy.com:8015/images/22657fda351dd313d4a40553f5446af8.png";
        _doctor.doctorName = @"谢维";
    }
    return _doctor;
}
-(MedicalInfo *)medicalInfo {
    if (!_medicalInfo) {
        _medicalInfo = [[MedicalInfo alloc]init];
        _medicalInfo.consultDisease = @"感冒sssss";
        _medicalInfo.consultContent = @"流鼻涕，很难受，而且头很痛ssssss流鼻涕，很难受，而且头很痛ssssss流鼻涕，很难受，而且头很痛ssssss流鼻涕，很难受，而且头很痛ssssss流鼻涕，很难受，而且头很痛ssssss流鼻涕，很难受，而且头很痛ssssss流鼻涕，很难受，而且头很痛ssssss流鼻涕，很难受，而且头很痛ssssss流鼻涕，很难受，而且头很痛ssssss流鼻涕，很难受，而且头很痛ssssss流鼻涕，很难受，而且头很痛ssssss流鼻涕，很难受，而且头很痛ssssss流鼻涕，很难受，而且头很痛ssssss";
    }
    return _medicalInfo;;
}
-(VCParam *)param {
    if (!_param) {
        _param = [[VCParam alloc]init];
        _param.number = @"wangge"; //  账户名或账户唯一标记
        _param.member = self.member;
        _param.doctor = self.doctor;
        _param.medicalInfo = self.medicalInfo;
        
        /// 再次问诊时必要参数
        _param.registerID = @"ba2c2e3a0cc54ed3b4858ea5f1985ae3";
        _param.channleId = @"200008766";
    }
    return _param;;
}
-(MBProgressHUD *)showHUD {
    
    _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    _hud.removeFromSuperViewOnHide = YES;
    _hud.mode = MBProgressHUDModeIndeterminate;
    _hud.label.text = @"";
    _hud.label.numberOfLines = 0;
    _hud.contentColor = [UIColor whiteColor];
    _hud.bezelView.color = [[UIColor blackColor] colorWithAlphaComponent:0.8];
    _hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    return _hud;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
         __weak typeof(self)weakSelf = self;

     self.manager.param = self.param;
     self.manager.showVC = self.navigationController;
     self.manager.taskHandler = ^(NSString * _Nullable taskTitle, NSProgress * _Nullable progress, BOOL hidden){
         if (taskTitle) {
             weakSelf.hud.label.text = taskTitle;
         }
         if (progress) {
             weakSelf.hud.mode = MBProgressHUDModeAnnularDeterminate;
             weakSelf.hud.progressObject = progress;
         }else{
             weakSelf.hud.mode = MBProgressHUDModeIndeterminate;
         }
         if (hidden) {
             [weakSelf.hud hideAnimated:YES];
         }
     };
     self.manager.completeHandler = ^( TaskType type,id _Nullable result, NSError * _Nullable error){
         if (result) {
             NSLog(@"%@",result);
             switch (type) {
                 case TaskTypeLogin:
                     
                     break;
                 case TaskTypeGetRecipeFiles:
                 {
                     if ([result isKindOfClass:[NSURL class]]) {
                         [weakSelf seeRecipeFile:(NSURL *)result];
                     }
                 }
                 default:
                     break;
             }
             
         }
         if (error) {
             NSLog(@"%@",error);
         }
     };
}
- (IBAction)clickeUploadBtn:(id)sender {
    __weak typeof(self)weakSelf = self;
    ZLPhotoActionSheet * ac = [[ZLPhotoActionSheet alloc]init];
    ac.configuration.maxSelectCount = 3;
    ac.configuration.maxPreviewCount = 0;
    ac.configuration.allowSelectVideo = NO;
    [ac showPreviewAnimated:YES sender:self];
    [ac setSelectImageBlock:^(NSArray<UIImage *> * _Nullable images, NSArray<PHAsset *> * _Nonnull assets, BOOL isOriginal) {
        weakSelf.medicalInfo.attachmentImage = images;
    }];
}
- (IBAction)clickeEnterConsultationBtn:(id)sender {
    
    [self showHUD];
    [self.manager enterConsultationRoom];
    
}
- (IBAction)clickeAgainEnterRoomBtn:(id)sender {
    
    [self showHUD];
    [self.manager againEnterConsultationRoom];
    
}

- (IBAction)clickeGetRecipeFiles:(id)sender{
    [self showHUD];
    
    [self.manager getRegistersInfo]; //通过字段[RecipeFileUrl] 判断是否已开处方
//    [self.manager getRecipeFiles];
//    [self.manager getFilesDownload];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)seeRecipeFile:(NSURL *)url
{
    UIDocumentInteractionController * docVC = [UIDocumentInteractionController interactionControllerWithURL:url];
    docVC.name = @"处方详情";
    docVC.delegate = self;
    [docVC presentPreviewAnimated:true];
}

- (UIViewController *)documentInteractionControllerViewControllerForPreview:(UIDocumentInteractionController *)controller
{
    return self;
}

@end
