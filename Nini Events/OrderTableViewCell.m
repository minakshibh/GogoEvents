
#import "OrderTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "AppDelegate.h"

@implementation OrderTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}
-(void)setLabelText:(NSString*)orderName :(int)quantity :(NSString*)price :(UIImage*)imageUrl :(NSData*)imageData{
    AppDelegate*appdelegate=[[UIApplication sharedApplication]delegate];

    name.text = [[NSString stringWithFormat:@"%@",orderName]uppercaseString];
    priceLbl.text = [NSString stringWithFormat:@"%@%.2f",appdelegate.currencySymbol,[price floatValue]];
    quantityLbl.text = [NSString stringWithFormat:@"%d",quantity];
   // NSData* data = [[NSData alloc] initWithBase64EncodedString:imageUrl options:0];
    // UIImage* img1 = [UIImage imageWithData:data];
    productImageView.image = [UIImage imageWithData:imageData];
    

   // [productImageView setImage:imageUrl];
    
}

@end
