MSSidebarController
===================

## Description:
Sidebar controller with customizable animations, implemented using a state machine.

## How to Use:

You must instantiate the [controller](MSSidebarController/Classes/Public/MSSidebarController.h) with the menu, and the currently active view controller:
```objc
[[MSSidebarController alloc] initWithMenuViewController:menuVC
                                   activeViewController:activeVC
                                        animatorFactory:animatorFactory];
```

You must also implement all three animation protocols:
```objc
@protocol MSSidebarDisplayViewControllerAnimator <NSObject>

- (void)sidebarController:(MSSidebarController *)sidebarController
willDisplayViewController:(UIViewController *)newViewController
          completionBlock:(void (^)(void))completionBlock;

@end

@protocol MSSidebarDisplayMenuAnimator <NSObject>

- (void)sidebarController:(MSSidebarController *)sidebarController
willDismissViewController:(UIViewController *)currentViewController
           andDisplayMenu:(UIViewController *)menuController
          completionBlock:(void (^)(void))completionBlock;

@end

@protocol MSSidebarHideViewControllerAnimator <NSObject>

- (void)sidebarController:(MSSidebarController *)sidebarController
   willHideViewController:(UIViewController *)currentViewController
  toShowNewViewController:(UIViewController *)newViewController
          completionBlock:(void (^)(void))completionBlock;

@end
```

View controllers inside of ```MSSidebarController``` will have a [sidebarController property](MSSidebarController/Classes/Public/UIViewController+MSSidebarController.h) set,
which you can use to change the state of the controller. Example:
```objc
[self.sidebarController showMenu];
[self.sidebarController restoreLastViewController];
[self.sidebarController showViewController:SomeOtherController.new];
```

## Instalation:
- Using [Cocoapods](http://cocoapods.org/):

Just add this line to your `Podfile`:

```
pod 'MSSidebarController', '~> 1.0.0'
```

- Manually:

Simply add the files under [Classes](MSSidebarController/Classes) to your project.

## Compatibility

- Supports iOS iOS7+.

## License
`MSSidebarController` is available under the WTFPL license. See the [LICENSE file](LICENSE) for more info.
