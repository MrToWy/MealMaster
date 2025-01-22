# MealMaster - AI-Powered Meal Planning App
MealMaster is a student project developed as part of the Mobile Interaction Design course.

The app is primarily designed for Android devices and leverages OpenAI API to help you create
personalized meal plans.
Simply take pictures of your ingredients, and MealMaster will generate a weekly plan with recipes
tailored to your available stocks.

Start planning smarter, reducing waste, and enjoying delicious meals with MealMaster!

## Requirements

To use MealMaster, you will need an OpenAI API key.
Additionally, the app requires your Android device to run on a minimum SDK version of 23 or higher.

## Used Packages

- [Isar](https://pub.dev/packages/isar) - Database
- [Flex Color Scheme](https://pub.dev/packages/flex_color_scheme) - Use Color Scheme
- [Http](https://pub.dev/packages/http) - Send HTTP Requests
- [Image Picker](https://pub.dev/packages/image_picker) - Access to the device's camera and gallery
- [Record](https://pub.dev/packages/record) - Audio recorder from microphone
- [Path Provider](https://pub.dev/packages/path_provider) - Get the path of the device's storage
- [Provider](https://pub.dev/packages/provider) - State Management
- [Intl](https://pub.dev/packages/intl) - Internationalization and localization

## Development

### How to create a new release
1. Create a tag (e.g. 0.0.1)
2. Push the tag
3. GitHub will create a new apk + release automatically

### Database
We are using Isar v3 (Community) for our database.
Documentation: https://isar-community.dev/v3/de/

#### Change database tables
1. Add a collection-class, or edit an existing one (e.g. lib/db/user.dart)
2. When adding a new class XYZ, add the code `part 'xyz.g.dart';`
3. Run the following command 
```shell
dart run build_runner build --delete-conflicting-outputs
```

## Demo

<img src="assets/mealmaster.gif" alt="MealMaster" style="width:200px; height:auto;">

