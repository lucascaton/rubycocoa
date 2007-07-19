# -*- mode:ruby; indent-tabs-mode:nil; coding: utf-8 -*-

module OSX::OCClsWrapper
  def create_default()      self.alloc.init end
  def create_with_str(arg)  raise NotImplementedError end
  def create_with_path(arg) raise NotImplementedError end
  def create_with_io(arg)   raise NotImplementedError end
  def create_with_url(arg)  raise NotImplementedError end

  def create(arg=nil)
    case arg
    when nil           then create_default
    when IO            then create_with_io(arg)
    when /^[a-zA-Z]+:/ then create_with_url(arg)
    when String        then create_with_str(arg)
    when Hash
      case
      when arg[:str]    then create_with_str(arg[:str])
      when arg[:string] then create_with_str(arg[:string])
      when arg[:path]   then create_with_path(arg[:path])
      when arg[:io]     then create_with_io(arg[:io])
      when arg[:url]    then create_with_url(arg[:url])
      else              raise ArgumentError
      end
    end
  end
end

class OSX::NSURL
  def self.create_with_url(str)   self.URLWithString(str)    end
  def self.create_with_str(str)   create_with_path(str)      end
  def self.create_with_path(path) self.fileURLWithPath(path) end
end

class OSX::NSData
  def self.create_with_str(str)   self.dataWithBytes_length(str, str.size) end
  def self.create_with_path(path) self.dataWithContentsOfFile(path) end
  def self.create_with_url(url)   self.dataWithContentsOfURL(OSX::NSURL.create(url)) end
  def self.create_with_io(io)     create_with_str(io.read) end
end

class OSX::NSImage
  def self.create_with_path(path) self.alloc.initWithContentsOfFile(path) end
  def self.create_with_str(str)   create_with_path(str)  end
  def self.create_with_url(url)
    self.alloc.initWithContentsOfURL(OSX::NSURL.create(url))
  end
end

class OSX::NSWindow
  DEFAULT_SIZE   = [200, 150]

  def self.create(*arg)
    case arg.size
    when 0 then create_with_frame(DEFAULT_SIZE)
    when 2 then create_with_frame(arg)
    when 4 then create_with_frame(arg)
    when 1 then
      arg = arg.shift
      case arg
      when Hash  then create_with_hash(arg)
      when Array then create(*arg)
      else raise ArgumentError
      end
    else raise ArgumentError
    end
  end

  def self.create_with_hash(opt)
    raise NotImplementedError
  end

  def self.create_with_frame(frame)
    if frame.size == 2 then
      frame = [0, 0] + frame
      size = OSX::NSScreen.mainScreen.frame.size
      frame[0] = OSX::NSScreen.mainScreen.frame.size.width  - frame[2] - 10
      frame[1] = OSX::NSScreen.mainScreen.frame.size.height - frame[3] - 50
    elsif frame.size != 4 then
      raise ArgumentError
    end
    win = self.alloc.
      objc_send( :initWithContentRect, frame,
                 :styleMask, OSX::NSTitledWindowMask +
                 OSX::NSResizableWindowMask +
                 OSX::NSClosableWindowMask,
                 :backing, OSX::NSBackingStoreBuffered,
                 :defer, false )
    win.makeKeyAndOrderFront(OSX::NSApp)
    win
  end
end

class OSX::NSView
  def self.create(*arg)
    case arg.size
    when 0 then self.alloc.init
    when 2 then self.alloc.initWithFrame([0, 0] + arg)
    when 4 then self.alloc.initWithFrame(arg)
    when 1 then
      arg = args.shift
      if arg.is_a? Array then
        create(*arg)
      else
        raise ArgumentError
      end
    else raise ArgumentError
    end
  end
end
