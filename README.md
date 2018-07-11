# iOS Template based on Swift 4.
**iOS base** is a boilerplate project for new projects using Swift 4.1(Readme is inspired from Rootstrap). The main objective is helping any new projects jump start into feature development by providing a handful of functionalities.

## Features
This template comes with:
#### Main
- Complete **API client** class to easily communicate with **REST services**.
- Complete **MVVM**  based pattern for better implementation.
- Examples for **account creation**.
- Useful classes to **manage User and Session data**.
- Handy **helpers** and **extensions** to make your coding experience faster and easier.
- Added  **SwiftLint**  for betterment of coding standards.


To use them simply download the branch and locally rebase against master/develop from your initial **iOS base** clone.

## How to use
1. Clone repo.
2. Change the name of the project on the left sidebar in Xcode.
3. Go to Manage Schemes and change the name to the new one.
4. Search for the name `ios_bp_swift4` in the entire project and replace all occurrences for the new name(If your project name contains a dash then use an underscore instead).
5. Close Xcode.
6. Rename the main and the source folder.
7. Right click the project bundle `.xcodeproj` file and select “Show Package Contents” from the context menu.
8. Open the `.pbxproj` file with any text editor.
9. Search and replace any occurrence of `ios-bp-swift4` and `ios_bp_swift4` and replace it with the new folder name. If the new folder name contains any dashes please use underscore instead when replacing `ios_bp_swift4`.
10. Save the file.
11. Open `Podfile` and change the target name with the new name of your project.
12. Delete the `*.workspace` file.
13. Run `pod install`.
14. Done :)

To manage user and session persistence after the original sign in/up we store that information in the native UserDefaults. The parameters that we save are due to the usage of [Devise Token Auth](https://github.com/lynndylanhurley/devise_token_auth) for authentication on the server side. Suffice to say that this can be modified to be on par with the server authentication of your choice.

## Pods
#### Main
- [Alamofire](https://github.com/Alamofire/Alamofire) for easy and elegant connection with an API.

## To Do
- Object Mapper.
- Key storage on a plist.
- Font Extensions.

## License

iOS-Base is available under the Apache License 2.0. See the LICENSE file for more info.
