//
//  PatientViewModel.h
//  iosAdvanced
//
//  Created by 杨世川 on 2018/6/22.
//  Copyright © 2018年 杨世川. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PatientModel.h"
#import "PatientBaseItem.h"

@interface PatientViewModel : NSObject
//处理Item
- (void)dealItemWithPatientModel:(PatientModel *)patientModel Success:(void(^)(NSArray<PatientBaseItem *> *result))success;


@end
