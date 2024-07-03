#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint the_mailer.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'the_mailer'
  s.version          = '0.0.1'
  s.summary          = 'A new plugin for sending emails.'
  s.description      = <<-DESC
A new plugin for sending emails using the default email app.
                       DESC
  s.homepage         = 'http://vexellab.com'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Vexellab' => 'hello@vexellab.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.dependency 'Flutter'
  s.platform = :ios, '9.0'

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.swift_version = '5.0'
end