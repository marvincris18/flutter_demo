# Quick Setup Guide for Facebook Integration

## Before You Start

This Facebook integration requires proper configuration to work. Follow these steps:

### 1. Facebook Developer Setup

1. Go to [Facebook for Developers](https://developers.facebook.com/)
2. Create a new app or use existing one
3. Add "Facebook Login" product to your app
4. Configure OAuth redirect URIs

### 2. Android Configuration

Add to `android/app/src/main/res/values/strings.xml`:
```xml
<resources>
    <string name="facebook_app_id">YOUR_FACEBOOK_APP_ID</string>
    <string name="fb_login_protocol_scheme">fbYOUR_FACEBOOK_APP_ID</string>
</resources>
```

Add to `android/app/src/main/AndroidManifest.xml`:
```xml
<uses-permission android:name="android.permission.INTERNET"/>

<application android:label="flutter_application_1">
    <meta-data android:name="com.facebook.sdk.ApplicationId" 
               android:value="@string/facebook_app_id"/>
    
    <activity android:name="com.facebook.FacebookActivity"
              android:configChanges="keyboard|keyboardHidden|screenLayout|screenSize|orientation"
              android:label="@string/app_name" />
    
    <activity android:name="com.facebook.CustomTabActivity" 
              android:exported="true">
        <intent-filter>
            <action android:name="android.intent.action.VIEW" />
            <category android:name="android.intent.category.DEFAULT" />
            <category android:name="android.intent.category.BROWSABLE" />
            <data android:scheme="@string/fb_login_protocol_scheme" />
        </intent-filter>
    </activity>
</application>
```

### 3. iOS Configuration

Add to `ios/Runner/Info.plist`:
```xml
<key>CFBundleURLTypes</key>
<array>
    <dict>
        <key>CFBundleURLName</key>
        <string>fbauth</string>
        <key>CFBundleURLSchemes</key>
        <array>
            <string>fbYOUR_FACEBOOK_APP_ID</string>
        </array>
    </dict>
</array>
<key>FacebookAppID</key>
<string>YOUR_FACEBOOK_APP_ID</string>
<key>FacebookDisplayName</key>
<string>Flutter Demo App</string>
```

### 4. Web Configuration (if needed)

Add to `web/index.html`:
```html
<script async defer crossorigin="anonymous" 
        src="https://connect.facebook.net/en_US/sdk.js"></script>
```

## Testing the Integration

1. Replace `YOUR_FACEBOOK_APP_ID` with your actual Facebook App ID
2. Run `flutter pub get` to install dependencies
3. Build and run the app
4. Navigate to the Facebook tab
5. Test the authentication flow

## Troubleshooting

- Ensure your Facebook app is in development mode for testing
- Check that redirect URIs match your app configuration
- Verify permissions are correctly requested in Facebook Developer Console
- Check device/emulator internet connectivity

## Production Deployment

Before deploying to production:
1. Submit your app for Facebook review if using advanced permissions
2. Switch Facebook app from development to live mode
3. Test thoroughly on physical devices
4. Update privacy policy to include Facebook integration