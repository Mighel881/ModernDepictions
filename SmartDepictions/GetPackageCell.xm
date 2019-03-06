#import "GetPackageCell.h"
#import "DepictionRootView.h"
#import "SmartDepictionDelegate.h"

@implementation GetPackageCell

- (instancetype _Nullable)initWithDepictionDelegate:(SmartDepictionDelegate *)delegate reuseIdentifier:(NSString * _Nonnull)reuseIdentifier {
	[super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
	_depictionDelegate = [delegate retain];
	queueButton = [[UIButton alloc] init];
	queueButton.titleLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightBold];
	queueButton.backgroundColor = [UIColor blueColor];
	queueButton.layer.masksToBounds = YES;
	queueButton.layer.cornerRadius = 16.0;
	[queueButton addTarget:self action:@selector(queueButtonTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
	self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, 92);
	self.contentView.frame = self.frame;
	iconView = [[UIImageView alloc] initWithFrame:CGRectMake(16, 16, 60, 60)];
	iconView.layer.masksToBounds = YES;
	iconView.layer.cornerRadius = 15.0;
	packageNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(
		iconView.frame.origin.x + iconView.frame.size.width + 10,
		21,
		self.contentView.frame.size.width - (iconView.frame.origin.x + iconView.frame.size.width + 10),
		24
	)];
	packageNameLabel.font = [UIFont systemFontOfSize:20 weight:UIFontWeightBold];
	authorLabel = [[UILabel alloc] initWithFrame:CGRectMake(
		packageNameLabel.frame.origin.x,
		packageNameLabel.frame.origin.y + 28,
		packageNameLabel.frame.size.width,
		19.5
	)];
	authorLabel.textColor = [UIColor lightGrayColor];
	authorLabel.font = [UIFont systemFontOfSize:16];
	self.package = delegate.package;
	[self.contentView addSubview:packageNameLabel];
	[self.contentView addSubview:iconView];
	[self.contentView addSubview:authorLabel];
	return self;
}

- (void)queueButtonTouchUpInside:(id)sender {
	[self.depictionDelegate handleModifyButton];
}

- (CGFloat)height {
	return 92.0;
}

- (void)setPackage:(Package *)package {
	if (!package) {
		packageNameLabel.text = @"?";
		return;
	}
	packageNameLabel.text = package.name;
	authorLabel.text = package.author.name;
	iconView.image = package.icon;
}

- (void)setButtonTitle:(NSString *)text {
	NSLog(@"setButtonTitle:\"%@\"", text);
	if (text) {
		if (![self.contentView.subviews containsObject:queueButton]) {
			[self.contentView addSubview:queueButton];
		}
		[queueButton
			setTitle:[NSString stringWithFormat:@"    %@    ", text.uppercaseString]
			forState:UIControlStateNormal
		];
		[queueButton sizeToFit];
		queueButton.frame = CGRectMake(
			self.contentView.frame.size.width - queueButton.frame.size.width - 23,
			0,
			queueButton.frame.size.width,
			queueButton.frame.size.height
		);
		queueButton.center = CGPointMake(
			queueButton.center.x,
			self.contentView.center.y
		);
		packageNameLabel.frame = CGRectMake(
			packageNameLabel.frame.origin.x,
			packageNameLabel.frame.origin.y,
			self.contentView.frame.size.width - (self.contentView.frame.size.width - queueButton.frame.origin.x) - packageNameLabel.frame.origin.x,
			packageNameLabel.frame.size.height
		);
		authorLabel.frame = CGRectMake(
			authorLabel.frame.origin.x,
			authorLabel.frame.origin.y,
			packageNameLabel.frame.size.width,
			authorLabel.frame.size.height
		);

	}
	else if ([self.contentView.subviews containsObject:queueButton]) {
		[[queueButton retain] removeFromSuperview];
		packageNameLabel.frame = CGRectMake(
			packageNameLabel.frame.origin.x,
			packageNameLabel.frame.origin.y,
			self.contentView.frame.size.width  - (iconView.frame.origin.x + iconView.frame.size.width + 10),
			packageNameLabel.frame.size.height
		);
	}
}

- (NSString * _Nullable)buttonTitle {
	return queueButton.titleLabel.text;
}

@end