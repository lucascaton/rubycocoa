#
#  $Id$
#
#  Copyright (c) 2001 FUJIMOTO Hisakuni <hisa@imasy.or.jp>
#
#  This program is free software.
#  You can distribute/modify this program under the terms of
#  the GNU Lesser General Public License version 2.
#

require 'osx/cocoa'

module OSX

  APP_DIR = File.expand_path(File.dirname($0)).
    split(File::SEPARATOR)[0..-3].join(File::SEPARATOR)

  RSRC_DIR = File.join(APP_DIR, 'Contents', 'Resources')
  $:.unshift(RSRC_DIR) unless $:.include?(RSRC_DIR)

  APP_BUNDLE = NSBundle.bundleWithPath(APP_DIR)

  def APP_BUNDLE.loadNibNamed_owner (name, owner)
    ret = self.loadNibFile(name, :externalNameTable, {'NSOwner' => owner}, :withZone, nil)
    return (ret != 0)
  end

  class NSBundle

    def NSBundle.loadNibNamed_owner (name, owner)
      return OSX::APP_BUNDLE.loadNibNamed_owner(name, owner)
    end
    
    def NSBundle.mainBundle
      return OSX::APP_BUNDLE
    end

  end

end
