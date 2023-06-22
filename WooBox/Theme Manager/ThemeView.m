//
//  ThemeView.m

#import "ThemeView.h"

@implementation ThemeView
#define OBJ_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)


#pragma mark -
#pragma mark - init methods

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self _init];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self _init];
    }
    return self;
}

- (id)init {
    if (self = [super init]) {
        [self _init];
    }
    return self;
}

- (void)_init {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(themeDidChangeNotification:) name:ThemeManagerDidChangeThemes object:nil];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self applyTheme];
}

- (void)dealloc {
    @try {
        [[NSNotificationCenter defaultCenter] removeObserver:self];
    }
    @catch (NSException *exception) {
        // do nothing, only unregistering self from notifications
    }
}


#pragma mark -
#pragma mark - set theme

- (void)applyTheme {
    
    UIColor *backgroundColor = nil;
    UIColor *borderColor = nil;
    if (_type == 0) {
        backgroundColor = [[ThemeManager sharedManager] colorForKey:@"header_background"];
        
    }else if (_type == 1) {
        backgroundColor = [[ThemeManager sharedManager] colorForKey:@"Secondary_Color2"];
        if (OBJ_IPAD) {
            self.layer.cornerRadius = 30.0;
        }else {
            self.layer.cornerRadius = 25.0;
        }
    }
    else if (_type == 2) {
        self.layer.borderWidth = 1;
        borderColor = [[ThemeManager sharedManager] colorForKey:@"Secondary_Color1"];
    }
    else if (_type == 3) {
        backgroundColor = [[ThemeManager sharedManager] colorForKey:@"header_color"];
        self.layer.shadowColor =  UIColor.groupTableViewBackgroundColor.CGColor;
        self.layer.shadowOpacity = 2.0;
        self.layer.shadowRadius = 2.0;
        self.layer.shadowOffset = CGSizeMake(0.0, 2.0);
    }
    else if (_type == 4) {
        backgroundColor = [[ThemeManager sharedManager] colorForKey:@"color5"];
        if (OBJ_IPAD) {
            self.layer.cornerRadius = 30.0;
        }else {
            self.layer.cornerRadius = 25.0;
        }
        self.layer.borderWidth = 1;
        self.layer.borderColor = UIColor.lightGrayColor.CGColor;
        
    }
    else if (_type == 5) {
        self.layer.borderWidth = 1;
        self.layer.borderColor = UIColor.groupTableViewBackgroundColor.CGColor;
        if (OBJ_IPAD) {
            self.layer.cornerRadius = 10.0;
        }else {
            self.layer.cornerRadius = 5.0;
        }
    }
    else if (_type == 6) {//view_background
        backgroundColor = [[ThemeManager sharedManager] colorForKey:@"Primary_Default_Color"];
    }
    else if (_type == 7) {
        self.layer.cornerRadius = self.frame.size.height/2;
        self.layer.masksToBounds = YES;
    }
    else if (_type == 8) {
        backgroundColor = [[ThemeManager sharedManager] colorForKey:@"view_background"];
    }
    else if (_type == 9) {
        backgroundColor = [[ThemeManager sharedManager] colorForKey:@"vw_secoundry_background"];
    }
    
    self.layer.borderColor = borderColor.CGColor;
    self.backgroundColor = backgroundColor;
}


#pragma mark -
#pragma mark - set observer for change theme

- (void)themeDidChangeNotification:(NSNotification *)notification {
    [self applyTheme];
}

@end
