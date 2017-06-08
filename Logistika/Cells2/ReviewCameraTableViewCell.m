//
//  ReviewCameraTableViewCell.m
//  Logistika
//
//  Created by BoHuang on 4/26/17.
//  Copyright © 2017 BoHuang. All rights reserved.
//

#import "ReviewCameraTableViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "CGlobal.h"

@implementation ReviewCameraTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)initMe:(ItemModel*)model{
    self.backgroundColor = [UIColor whiteColor];
    
    if (model.image_data == nil) {
        // path
        NSString* path = [NSString stringWithFormat:@"%@%@products/%@",g_baseUrl,PHOTO_URL,model.image];
        [_imgContent sd_setImageWithURL:[NSURL URLWithString:path]
                        placeholderImage:[UIImage imageNamed:@"placeholder.png"]
                               completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                   model.image_data = image;
                               }];
    }else{
        self.imgContent.image = model.image_data;
    }
    
    
    
    self.lblQuantity.text = model.quantity;
    self.lblWeight.text = model.weight;
    
    
    self.data = model;
}
@end
