# VideoConsultationSDK

[![Build Status](https://travis-ci.com/zhenlove/VideoConsultationSDK.svg?branch=master)](https://travis-ci.com/zhenlove/VideoConsultationSDK)
[![Version](https://img.shields.io/cocoapods/v/VideoConsultationSDK.svg?style=flat)](https://cocoapods.org/pods/VideoConsultationSDK)
[![License](https://img.shields.io/cocoapods/l/VideoConsultationSDK.svg?style=flat)](https://cocoapods.org/pods/VideoConsultationSDK)
[![Platform](https://img.shields.io/cocoapods/p/VideoConsultationSDK.svg?style=flat)](https://cocoapods.org/pods/VideoConsultationSDK)

## 例

要运行示例项目，请克隆存储库，然后首先从Example目录运行`pod install`。


## 安装

可通过[CocoaPods]（https://cocoapods.org）获得VideoConsultation。 安装
只需将以下行添加到您的Podfile中：

```ruby
pod 'VideoConsultationSDK'
```

## 使用

- 设置权限
```xml
<key>NSPhotoLibraryUsageDescription</key>
<string>需要访问相册</string>
<key>NSMicrophoneUsageDescription</key>
<string>需要访问麦克风</string>
<key>NSCameraUsageDescription</key>
<string>需要访问相机</string>
```

- 设置环境
```objc
@import KMNetwork;
@import VideoConsultation;

[KMServiceModel setupParameterWithAppid:@"JSKMEHospIOS"
                              appsecret:@"JSKMEHospIOS@2016"
                                 appkey:@"0123456789ios#2016"
                                  orgid:@""
                            environment:EnvironmentTesting3];
```
- 登录
```objc
    [[VideoConsultationManager sharedInstance] loginWithNumber:@"wangge" handler:^(TaskType type,id result,NSError * error){
        NSLog(@"登录成功");
    }];
```

- 创建订单
```objc
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
```

- 进入诊室
```objc
[[VideoConsultationManager sharedInstance] enterConsultationRoomWithChannleID:self.channelID
                                                                         doctorID:self.doctorID
                                                                           showVC:self.navigationController
                                                                          handler:^(TaskType type,id result,NSError * error) {
        NSLog(@"进入诊室%@",result);
    }];
```

- 获取诊室候诊人数量
```objc
[[VideoConsultationManager sharedInstance] getRoomWaitCountWithChannleID:self.channelID doctorID:self.doctorID handler:^(TaskType type,id result,NSError * error) {
        NSLog(@"获取候诊人数%@",result);
    }];
```

- 查询订单详情
```objc
 [[VideoConsultationManager sharedInstance] getRegistersInfoWithRegisterID:self.opdRegisterID handler:^(TaskType type,id result,NSError * error) {
        NSLog(@"查询订单详情%@",result);
    }];
```
- 下载处方
```objc
[[VideoConsultationManager sharedInstance] getFilesDownloadWithRegisterID:self.opdRegisterID handler:^(TaskType type,id result,NSError * error) {
        NSLog(@"下载处方%@",result);
    }];
```

- 清理缓存
```objc
if ([[VideoConsultationManager sharedInstance]removeFilePDF]) {
        NSLog(@"清理缓存成功");
}
```

- 问诊结束回调
```objc
[VideoConsultationManager sharedInstance].completeHandler = ^(TaskType type, id  result, NSError * error) {
    if (type == TaskTypeVisitCompleted) {
        NSLog(@"%@",result);
    }
};
```
## 作者

zhenlove, 121910347@qq.com

## 许可

VideoConsultationSDK在MIT许可下可用。 有关更多信息，请参见LICENSE文件。
