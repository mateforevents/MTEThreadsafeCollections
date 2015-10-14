Pod::Spec.new do |spec|
  	spec.name         = "MTEThreadsafeCollections"
  	spec.version      = "1.0.1"
  	spec.summary      = "A collection of threadsafe replacements for NSMutableArray, NSMutableDictionary and NSMutableSet"
  	spec.homepage	  = "https://github.com/mateforevents/MTEThreadsafeCollections"
  	spec.license      = "MIT"
  	spec.author       = { "mheicke" => "matthias.heicke@mateforevents.com" }
  	spec.social_media_url = "https://www.facebook.com/mateforevents"
  	spec.platform     = :ios, "7.0"
	spec.requires_arc = true
	spec.source       = { :git => "https://github.com/mateforevents/MTEThreadsafeCollections.git", :tag => "v#{spec.version}" }
	spec.description  = <<-DESC
A collection of threadsafe replacements for NSMutableArray, NSMutableDictionary and NSMutableSet
    	DESC  	

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
