# Uncomment the next line to define a global platform for your project
#platform :ios, '9.0'

install! 'cocoapods', :deterministic_uuids => false

target 'push' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!
  
  pod "CleverTap-iOS-SDK", "7.3.1"
  # Pods for push
  
  target 'NotificationService' do
    # Pods for NotificationService
    pod 'CTNotificationService'
    pod "CleverTap-iOS-SDK", "7.3.1"
  end
  
  target 'NotificationContentDemo' do
    pod 'CTNotificationContent', "1.1.0"
    pod "CleverTap-iOS-SDK", "7.3.1"
  end
  
#  target 'RichTest' do
#    pod "CleverTap-iOS-SDK"
#  end
  
end
