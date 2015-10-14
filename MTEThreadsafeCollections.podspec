Pod::Spec.new do |spec|
  	spec.name         = "MTEThreadsafeCollections"
  	spec.version      = "1.0.0"
  	spec.summary      = "A collection of threadsafe replacements of NSMutableArray, NSMutableDictionary and NSMutableSet"
  	spec.homepage	  = "https://www.mateforevents.com"
  	spec.license      = "MIT"
  	spec.author       = { "mheicke" => "matthias.heicke@mateforevents.com" }
  	spec.platform     = :ios, "7.0"
	spec.requires_arc = true
	spec.source       = { :git => "https://github.com/mateforevents/MTEThreadsafeCollections.git", :tag => "v#{spec.version}" }

	spec.subspec 'Array' do |ss|
		ss.source_files  = "Pod/MTEThreadsafeArray.{h,m}"
  	end

	spec.subspec 'Dictionary' do |ss|
		ss.source_files  = "Pod/MTEThreadsafeDictionary.{h,m}"
  	end

	spec.subspec 'Set' do |ss|
		ss.source_files  = "Pod/MTEThreadsafeSet.{h,m}"
  	end

end
