# VideoConsultationSDK

[![CI Status](https://img.shields.io/travis/zhenlove/VideoConsultationSDK.svg?style=flat)](https://travis-ci.org/zhenlove/VideoConsultationSDK)
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

[KMServiceModel setupParameterWithAppid:@"*********"
                              appsecret:@"*********"
                                 appkey:@"*********"
                                  orgid:@""
                            environment:EnvironmentTesting3];
```
- 设置患者信息
```objc
Member *member = [[Member alloc]init];
member.phone = @"13760291826";
member.birthday = @"2001-01-09";
member.name = @"林祥";
member.gender = @"男";
member.allergicRemark = @"花粉过敏,等等";
```

- 设置医生信息
```objc
DoctorInfo* doctor = [[DoctorInfo alloc]init];
doctor.doctorName = @"谢维";
doctor.doctorId = @"78ee0381bbb541aba41fbc2ecb4566ba";
doctor.doctorHeadUrl = @"https://tstore2.kmwlyy.com:8015/images/22657fda351dd313d4a40553f5446af8.png";
```

- 设置问诊信息
```objc
MedicalInfo *medicalInfo = [[MedicalInfo alloc]init];
medicalInfo.consultDisease = @"感冒sssss";
medicalInfo.consultContent = @"流鼻涕，很难受，而且头很痛";
```

- 设置参数
```objc
VCParam * param = [[VCParam alloc]init];
param.number = @"wangge"; //  账户名或账户唯一标记,登录时必要参数
param.member = self.member; // 创建问诊时必要参数
param.doctor = self.doctor; //进入诊室时必要参数
param.medicalInfo = self.medicalInfo; // 创建问诊时必要参数

/// 再次问诊时必填参数
param.registerID = @"038c7750335d44a297e535a4ce4ba4bb"; // 查询订单数据和处方时必要参数
param.channleId = @"200008755"; //进入诊室时必要参数
```
- 初始化
```objc
VideoConsultationManager *manager = [[VideoConsultationManager alloc]init];
manager.param = self.param;
manager.showVC = self.navigationController;
```

- 任务状态回调
```objc
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
```

- 数据回调、根据任务类型保存需要数据
```objc
self.manager.completeHandler = ^( TaskType type,id _Nullable result, NSError * _Nullable error){
    if (result) {
        NSLog(@"%@",result);
        switch (type) {
            case TaskTypeLogin:
                
                break;
            case TaskTypeGetRecipeFiles:
            {
                if ([result isKindOfClass:[NSURL class]]) {
                    /// 查看处方
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
```
- 创建问诊并进入诊室
```objc
[self.manager enterConsultationRoom];
```

- 再次进入诊室
```objc
[self.manager againEnterConsultationRoom];
```

- 获取订单信息
```objc
[self.manager getRegistersInfo];
```

- 获取处方详情
```objc
[self.manager getRecipeFiles];
```

- 下载处方PDF
```objc
[self.manager getFilesDownload];
```

## 作者

zhenlove, 121910347@qq.com

## 许可

VideoConsultationSDK在MIT许可下可用。 有关更多信息，请参见LICENSE文件。
