# SiaraShield Flutter

siarashield_flutter is a package that enables authentication using SiaraShield in Flutter applications.

## Getting Started

To use this package, add `siarashield_flutter` as a dependency in your `pubspec.yaml` file.

### Installation

Add the following line to your `pubspec.yaml`:

```yaml
dependencies:
  siarashield_flutter: latest_version
```

Then, run:

```sh
flutter pub get
```

## Usage

To authenticate using SiaraShield, you need a `MasterUrlId`, which can be obtained from the [SiaraShield Portal](https://mycybersiara.com/) after registering your package name.

### Minimal Example

```dart
import 'package:siarashield_flutter/siarashield_flutter.dart';

CyberSiaraWidget(
  loginTap: (bool isSuccess) {
    if (isSuccess) {
      // Handle successful authentication
      print("Authentication Successful: \$isSuccess");
    } else {
      // Handle authentication failure
      print("Authentication Failed");
    }
  },
  cyberSiaraModel: CyberSiaraModel(
    masterUrlId: 'TEST-CYBERSIARA', // Master URL ID
    requestUrl: 'com.app.testapp', //Package name or Website Url
    privateKey: 'TEST-CYBERSIARA', // Private Key
  ),
),
```
### requestUrl

The value of `requestUrl` depends on the platform:

| Platform | Value |
|----------|-------|
| Android | Application package name (e.g. `com.example.myapp`) |
| iOS | Application bundle identifier (e.g. `com.example.myapp`) |
| Web | Website URL/domain registered in SiaraShield (e.g. `https://example.com`) |

> **Important:** The value provided in `requestUrl` must exactly match the application package name, bundle identifier, or website URL registered in the SiaraShield Portal.

## Parameters

| Parameter      | Type      | Description |
|---------------|----------|-------------|
| `loginTap`    | Function | Callback function that returns `true` on successful authentication and `false` otherwise. |
| `masterUrlId` | String   | The Master URL ID obtained from SiaraShield Portal. |
| `requestUrl`  | String   | The package name registered with SiaraShield. |
| `privateKey`  | String   | The private key used for authentication. |

## Additional Information

For more details, visit the [SiaraShield Portal](https://mycybersiara.com/) or refer to the official documentation.

---

**Note:** Ensure that you handle authentication responses securely and follow best practices for storing sensitive credentials in your application.

