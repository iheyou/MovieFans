//
//  FilmPhotosModel.h
//  MovieFans
//
//  Created by hy on 16/1/12.
//  Copyright © 2016年 hy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseModel.h"
#import <MJExtension.h>

@interface FilmPhotosModel : BaseModel


@property (nonatomic, copy) NSString *photo_url_mid;

@property (nonatomic, copy) NSString *photo_url_small;

@property (nonatomic, copy) NSString *photo_url;


@end
