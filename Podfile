# Uncomment the next line to define a global platform for your project
#platform :ios, '9.0'

install! 'cocoapods', :deterministic_uuids => false

target 'push' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!
  
  pod "CleverTap-iOS-SDK", "3.9.2"
  # Pods for push
  
  target 'NotificationService' do
    # Pods for NotificationService
    pod 'CTNotificationService'
    pod "CleverTap-iOS-SDK"
  end
  
  target 'NotificationContentDemo' do
    pod 'CTNotificationContent'
    pod "CleverTap-iOS-SDK"
  end
  
#  pod 'CleverTap-iOS-SDK', '5.0.1'
#  pod 'CTNotificationService'
#  pod 'CTNotificationContent'
#  pod 'Firebase/Analytics'
#  pod 'Firebase/Crashlytics'
#  pod 'Firebase/Core'
#  pod 'Firebase/Firestore'
#  pod 'Firebase/DynamicLinks'
#  pod 'Firebase/Messaging'
  
end
