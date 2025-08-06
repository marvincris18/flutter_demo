# Facebook Authentication Setup

This Flutter demo app now includes Facebook authentication. To complete the setup:

## 1. Facebook App Configuration

1. Go to [Facebook Developers](https://developers.facebook.com/)
2. Create a new app or use an existing one
3. Add the Facebook Login product to your app
4. Get your App ID and Client Token

## 2. Android Configuration

Update the following file with your Facebook credentials:
- `android/app/src/main/res/values/strings.xml`

Replace:
- `YOUR_APP_ID` with your Facebook App ID
- `YOUR_CLIENT_TOKEN` with your Facebook Client Token

## 3. iOS Configuration (if needed)

For iOS support, additional configuration is required in the iOS project files.

## 4. Testing

The app will show a login screen when no user is authenticated. After successful Facebook login, users can:
- Generate and favorite word pairs
- View their profile information
- Sign out

## Features Implemented

- ✅ Facebook OAuth authentication
- ✅ User-friendly login UI
- ✅ Token management with local storage
- ✅ Modular authentication service
- ✅ Profile management
- ✅ Navigation between authenticated and unauthenticated states