Pod::Spec.new do |s|
  s.name         = "WaitForIt"
  s.version      = "2.0.0"
  s.platform     = :ios
  s.ios.deployment_target = '9.0'
  s.summary      = "Events and time based iOS app scenarios made easy."
  s.description  = <<-DESC
WaitForIt simplifies implementing common app development scenarios, like:
"Display a tutorial screen when user launches an app for the first time."
"Ask user for a review, but only if he installed the app more then two weeks ago and launched it at least 5 times."
"Ask user to buy a subscription once every 3 days, but no more then 5 times in total."

etc.
DESC
  s.homepage     = "https://github.com/pawurb/WaitForIt"
  s.license      =  { :type => "MIT", :file => "LICENSE" }
  s.author       = { "pawurb" => "p.urbanek89@gmail.com" }
  s.source       = { :git => "https://github.com/pawurb/WaitForIt.git", :tag => "#{s.version}" }
  s.source_files = "WaitForIt/**/*.swift"
end
