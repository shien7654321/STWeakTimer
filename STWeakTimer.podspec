Pod::Spec.new do |s|

  s.name         = "STWeakTimer"
  s.version      = "0.0.1"
  s.summary      = "An alternative to NSTimer."
  s.homepage     = "https://github.com/shien7654321/STWeakTimer"
  s.author       = { "Suta" => "shien7654321@163.com" }
  s.source       = { :git => "https://github.com/shien7654321/STWeakTimer.git", :tag => s.version.to_s }
  s.platform     = :ios, "8.0"
  s.requires_arc = true
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.frameworks   = "Foundation"
  s.source_files = "STWeakTimer/*.{h,m}"
  s.compiler_flags = "-fmodules"
  s.description    = <<-DESC
  STWeakTimer is an alternative to NSTimer.
                       DESC

end
