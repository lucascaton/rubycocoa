#
#  $Id$
#
#  Copyright (c) 2001 FUJIMOTO Hisakuni
#

require 'nkf'

module OSX

  # from NSBundle
  def NSLocalizedString (key, comment = nil)
    OSX::NSBundle.mainBundle.
      localizedStringForKey_value_table(key, "", nil)
  end
  def NSLocalizedStringFromTable (key, tbl, comment = nil)
    OSX::NSBundle.mainBundle.
      localizedStringForKey_value_table(key, "", tbl)
  end
  def NSLocalizedStringFromTableInBundle (key, tbl, bundle, comment = nil)
    bundle.localizedStringForKey_value_table(key, "", tbl)
  end
  module_function :NSLocalizedStringFromTableInBundle
  module_function :NSLocalizedStringFromTable
  module_function :NSLocalizedString

  # for NSData
  class NSData

    def NSData.dataWithRubyString (str)
      NSData.dataWithBytes_length( str )
    end

  end

  # for NSMutableData
  class NSMutableData

    def NSMutableData.dataWithRubyString (str)
      NSMutableData.dataWithBytes_length( str )
    end

  end

  # for NSString
  class NSString

    def NSString.guess_nsencoding(rbstr)
      case NSString.guess_encoding(rbstr)
      when NKF::JIS then NSISO2022JPStringEncoding
      when NKF::EUC then NSJapaneseEUCStringEncoding
      when NKF::SJIS then NSShiftJISStringEncoding
      else NSProprietaryStringEncoding
      end
    end

    def NSString.guess_encoding(rbstr)
      NKF.guess(rbstr)
    end

    # NKF.guess fails on ruby-1.8.2
    if NKF.respond_to?('guess1') && NKF::NKF_VERSION == "2.0.4"
      def NSString.guess_encoding(rbstr)
        NKF.guess1(rbstr)
      end
    end

    def NSString.stringWithRubyString (str)
      data = NSData.dataWithRubyString( str )
      enc = guess_nsencoding( str )
      NSString.alloc.initWithData_encoding( data, enc )
    end

  end

  # for NSMutableString
  class NSMutableString
    def NSMutableString.stringWithRubyString (str)
      data = NSData.dataWithRubyString( str )
      enc = NSString.guess_nsencoding( str )
      NSMutableString.alloc.initWithData_encoding( data, enc )
    end
  end

  # for NSApplication
  class NSApplication 
    
    def NSApplication.run_with_temp_app(terminate = true, &proc)
      # prepare delegate
      delegate = Class.new(OSX::NSObject).alloc.init
      def delegate.applicationDidFinishLaunching(sender)
	begin
	  @proc.call
	rescue Exception => err
	  $stderr.puts "#{err.message} (#{err.class})"  
	  $stderr.puts err.backtrace.join("\n    ")
	ensure
	  OSX::NSApplication.sharedApplication.terminate(self) if @terminate
	end
      end
      def delegate.proc=(block)
	@proc = block
      end
      def delegate.terminate=(terminate)
	@terminate = terminate
      end
      delegate.proc = proc
      delegate.terminate = terminate
      # run a new app
      app = NSApplication.sharedApplication
      app.setDelegate(delegate)
      app.run
    end

  end

  # This moved there as osx/coredata is now deprecated.
  module CoreData
    # define wrappers from NSManagedObjectModel
    def define_wrapper(model)
      unless model.isKindOfClass? OSX::NSManagedObjectModel
        raise RuntimeError, "invalid class: #{model.class}"
      end

      model.entities.to_a.each do |ent|
        klassname = ent.managedObjectClassName.to_s
        next if klassname == 'NSManagedObject'
        next unless Object.const_defined?(klassname)

        attrs = ent.attributesByName.allKeys.to_a.collect {|key| key.to_s}
        rels = ent.relationshipsByName.allKeys.to_a.collect {|key| key.to_s}
        klass = Object.const_get(klassname)
        klass.instance_eval <<-EOE_AUTOWRAP,__FILE__,__LINE__+1
          kvc_wrapper attrs
          kvc_wrapper_reader rels
        EOE_AUTOWRAP
      end
    end
    module_function :define_wrapper
  end

end