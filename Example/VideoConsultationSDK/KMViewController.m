//
//  KMViewController.m
//  VideoConsultationSDK
//
//  Created by zhenlove on 05/18/2020.
//  Copyright (c) 2020 zhenlove. All rights reserved.
//

#import "KMViewController.h"
#import <ZLPhotoBrowser/ZLPhotoBrowser.h>

@import KMNetwork;
@import VideoConsultation;
@interface KMViewController ()<UIDocumentInteractionControllerDelegate>
@property (nonatomic, assign) NSInteger channelID;
@property (nonatomic, copy) NSString * opdRegisterID;
@property (nonatomic, copy) NSString * doctorID;
@property (nonatomic, copy) NSArray<UIImage *> * imagesArr;
@end

@implementation KMViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
        /// 创建完订单后，需要保存参数
         self.channelID = 200008812;
         self.opdRegisterID = @"2189b33cf21946169142c551599568a6";
         self.doctorID = @"78ee0381bbb541aba41fbc2ecb4566ba";
             
         //        Member * member = [[Member alloc]init];
         //        member.phone = @"13760291826";
         //        member.birthday = @"2001-01-09";
         //        member.name = @"林祥";
         //        member.gender = @"男";
         //        member.allergicRemark = @"花粉过敏,等等";
         //
         //        DoctorInfo * doctor = [[DoctorInfo alloc]init];
         //    //        _doctor.doctorId = @"928e4ffd5873478ba1dabe3e483335a1";
         //    //        _doctor.doctorHeadUrl = @"https://tstore2.kmwlyy.com:8015/images/854874cb0ca5b3b12025351f37e02472.jpg";
         //    //        _doctor.doctorName = @"康美云";
         //        doctor.doctorId = @"78ee0381bbb541aba41fbc2ecb4566ba";
         //    //            _doctor.doctorHeadUrl = @"https://tstore2.kmwlyy.com:8015/images/22657fda351dd313d4a40553f5446af8.png";
         //    //            _doctor.doctorName = @"谢维";
         //
         //
         //        MedicalInfo *medicalInfo = [[MedicalInfo alloc]init];
         //        medicalInfo.consultDisease = @"感冒sssss";
         //        medicalInfo.consultContent = @"流鼻涕，很难受，而且头很痛ssssss流鼻涕，很难受，而且头很痛ssssss流鼻涕，很难受，而且头很痛ssssss流鼻涕";
         //        medicalInfo.attachmentImage = self.imagesArr;
         //
         //
         //        VCParam * param = [[VCParam alloc]init];
         //        param.member = member;
         //        param.doctor = doctor;
         //        param.medicalInfo = medicalInfo;
}
- (IBAction)clickeUploadBtn:(id)sender {
    __weak typeof(self)weakSelf = self;
    ZLPhotoActionSheet * ac = [[ZLPhotoActionSheet alloc]init];
    ac.configuration.maxSelectCount = 3;
    ac.configuration.maxPreviewCount = 0;
    ac.configuration.allowSelectVideo = NO;
    [ac showPreviewAnimated:YES sender:self];
    [ac setSelectImageBlock:^(NSArray<UIImage *> * _Nullable images, NSArray<PHAsset *> * _Nonnull assets, BOOL isOriginal) {
        weakSelf.imagesArr = images;
    }];
}
/// 初始化SDK
- (IBAction)clickeInitializationSDKBtn:(id)sender {
        // 设置环境
//    if ([KMServiceModel setupParameterWithAppid:@"JSKMEHospIOS"
//                                      appsecret:@"JSKMEHospIOS@2016"
//                                         appkey:@"0123456789ios#2016"
//                                          orgid:@""
//                                    environment:EnvironmentTesting3]) {
//        NSLog(@"初始化SDK成功");
//    }
}
/// 登录
- (IBAction)clickeLoginBtn:(id)sender {
    [[VideoConsultationManager sharedInstance] loginWithNumber:@"wangge" handler:^(TaskType type,id result,NSError * error){
        NSLog(@"登录成功");
    }];
}

/// 创建订单
- (IBAction)clickeEnterConsultationBtn:(id)sender {
    
    
    Member * member = [[Member alloc]init];
    member.phone = @"13760291826";
    member.birthday = @"2001-01-09";
    member.name = @"林祥";
    member.gender = @"男";
    member.allergicRemark = @"花粉过敏,等等";
    
    DoctorInfo * doctor = [[DoctorInfo alloc]init];
    doctor.doctorId = @"78ee0381bbb541aba41fbc2ecb4566ba";

    
    MedicalInfo *medicalInfo = [[MedicalInfo alloc]init];
    medicalInfo.consultDisease = @"感冒sssss";
    medicalInfo.consultContent = @"流鼻涕，很难受，而且头很痛ssssss流鼻涕，很难受，而且头很痛ssssss流鼻涕，很难受，而且头很痛ssssss流鼻涕";
    medicalInfo.attachmentImage = self.imagesArr;
    
    
    VCParam * param = [[VCParam alloc]init];
    param.member = member;
    param.doctor = doctor;
    param.medicalInfo = medicalInfo;
    
    

    
    
    __weak typeof(self)weakSelf = self;
    [[VideoConsultationManager sharedInstance] createOrder:param handler:^(TaskType type,id result,NSError * error) {
        if (type == TaskTypeCreateOrder) {
            NSLog(@"创建订单成功%@",result);
            if (result) {

                if ([result[@"Status"] intValue] == 0 && [result[@"Data"][@"ActionStatus"] isEqualToString:@"Success"]) {
                    weakSelf.channelID = [result[@"Data"][@"ChannelID"] integerValue];
                    weakSelf.opdRegisterID = result[@"Data"][@"OPDRegisterID"];
                }
            }
        }
    }];

}
/// 进入诊室
- (IBAction)clickeAgainEnterRoomBtn:(id)sender {

    [[VideoConsultationManager sharedInstance] enterConsultationRoomWithChannleID:self.channelID
                                                                         doctorID:self.doctorID
                                                                           showVC:self.navigationController
                                                                          handler:^(TaskType type,id result,NSError * error) {
        NSLog(@"进入诊室%@",result);
    }];
    
}
/// 获取候诊人数
- (IBAction)clickeRoomWaitCountBtn:(id)sender {
    [[VideoConsultationManager sharedInstance] getRoomWaitCountWithChannleID:self.channelID doctorID:self.doctorID handler:^(TaskType type,id result,NSError * error) {
        NSLog(@"获取候诊人数%@",result);
    }];
}
/// 查询订单详情
- (IBAction)clickeGetRecipeFiles:(id)sender{
    [[VideoConsultationManager sharedInstance] getRegistersInfoWithRegisterID:self.opdRegisterID handler:^(TaskType type,id result,NSError * error) {
        NSLog(@"查询订单详情%@",result);
    }];
}


/// 下载处方
- (IBAction)clickeDownloadRecipeBtn:(id)sender {

    __weak typeof(self)weakSelf = self;
    [[VideoConsultationManager sharedInstance] getFilesDownloadWithRegisterID:self.opdRegisterID handler:^(TaskType type,id result,NSError * error) {
        NSLog(@"下载处方%@",result);
        if (type == TaskTypeGetRecipeFiles) {
            if ([result isKindOfClass:[NSURL class]]) {
                [weakSelf seeRecipeFile:(NSURL *)result];
            }
        }
    }];
}
/// 清理缓存
- (IBAction)clickeCleanCacheBtn:(id)sender {
    if ([[VideoConsultationManager sharedInstance]removeFilePDF]) {
        NSLog(@"清理缓存成功");
    }
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
