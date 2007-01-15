#!/usr/bin/env ruby

# Created by Eloy Duran
# Copyright (c) 2007 Eloy Duran, SuperAlloy

def show_options
  puts "Usage:"
  puts "  #{__FILE__} build|clean [extra options]"
  puts ""
  puts "Options:"
  puts "  build  Create the RDoc documentation for the supported frameworks"
  puts "  clean  Remove all the files created by this tool"
  puts ''
  puts "Extra Options:"
  puts "  The extra options only apply to 'build' option and are options passed"
  puts "  to the actual rdocify_framework.rb script."
  puts "  These are:"
  puts "  -v Verbose output."
  puts "  -f Force the output files to be written even if there were errors during parsing."
  puts ''
  puts "Examples:"
  puts "  #{__FILE__} build"
  puts "  #{__FILE__} build -v -f"
  puts "  #{__FILE__} clean"
  puts ''
end

unless ARGV[0].nil?
  case ARGV[0]
  when 'build'
    # Check if there are any other args
    if ARGV.length > 1
      other_args = ARGV[1..-1]
    else
      other_args = []
    end
    
    SUPPORTED_FRAMEWORKS = ['/Developer/ADC Reference Library/documentation/Cocoa/Reference/ApplicationKit/']

    start_time = Time.now

    # Parse the rdoc for each supported framework
    SUPPORTED_FRAMEWORKS.each do |f|
      system "ruby gen_bridge_doc/rdocify_framework.rb #{other_args.join(' ')} '#{f}'"
    end

    # Create the rdoc files
    system "rdoc gen_bridge_doc/output/"

    puts ""
    puts "Total Cocoa Reference to RDoc processing time: #{Time.now - start_time} seconds"
  when 'clean'
    system "rm -r doc"
    system "rm -r gen_bridge_doc/output"
  else
    show_options
  end
else
  show_options
end