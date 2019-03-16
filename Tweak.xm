#import <UIKit/UIKit.h>
#import "Headers/Headers.h"
#import "SmartDepictions/SmartPackageController.h"

// Dirty function to check if a depiction is valid
static bool VerifySileoDepiction(NSDictionary *depiction) {
	return ([depiction[@"minVersion"] isKindOfClass:[NSString class]] &&
		[depiction[@"class"] isKindOfClass:[NSString class]] &&
		NSClassFromString(depiction[@"class"]) && (
			[(NSString *)depiction[@"class"] isEqualToString:@"DepictionTabView"] && (
				[depiction[@"tabs"] isKindOfClass:[NSArray class]] &&
				[(NSArray *)depiction[@"tabs"] count] > 0
			)
		)
	);
}

%hook CYPackageController

- (void *)initWithDatabase:(Database *)database forPackage:(NSString *)name withReferrer:(NSString *)referrer {
	@autoreleasepool {
		Package *package = [database packageWithName:name];
		if (package) {
			[package parse];
			NSString *rawDepictionURL = [package sileoDepiction];
			NSLog(@"Raw URL: %@", rawDepictionURL);
			if (rawDepictionURL) {
				NSURL *depictionURL = [NSURL URLWithString:rawDepictionURL];
				NSLog(@"Depiction URL: %@", depictionURL);
				if (depictionURL) {
					NSData *rawJSONDepiction = [NSData dataWithContentsOfURL:depictionURL];
					NSLog(@"Raw JSON Data: %@", rawJSONDepiction);
					if (rawJSONDepiction) {
						NSDictionary *JSONDepiction = [NSJSONSerialization
							JSONObjectWithData:rawJSONDepiction
							options:0
							error:nil
						];
						NSLog(@"Serialized data: %@", JSONDepiction);
						if (JSONDepiction && VerifySileoDepiction(JSONDepiction)) {
							SmartPackageController *newView = [[SmartPackageController alloc] initWithDepiction:[JSONDepiction copy] database:database packageID:[package id]];
							if (newView) {
								NSLog(@"New view: %@", newView);
								[self release]; // The CYPackageController is useless at this point
								NSLog(@"Returning...");
								return (void *)newView;
							}
						}
					}
				}
			}
		}
	}
	return %orig;
}

%end

%hook Package
%property (nonatomic, retain) NSString *sileoDepiction;

- (void)parse {
	%orig;
	id value = [self getField:@"sileodepiction"];
	self.sileoDepiction = [value isKindOfClass:[NSNull class]] ? nil : value;
}

%end

%ctor {
	if (class_getInstanceMethod([%c(Package) class], @selector(getField:)) != NULL) {
		NSLog(@"init");
		%init;
	}
}