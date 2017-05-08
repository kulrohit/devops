require 'puppet/resource'
require 'puppet/resource/catalog'
require 'fileutils'
require 'rubygems'
require 'facter'

Puppet::Type.type(:symlink).provide(:symlink) do
    desc "symlink"
		
    def create
				source = @resource[:name]
				target =@resource[:path]
			if File.symlink? target
				puts "link deleted and created"
				File.unlink target
				File.symlink source, target
			else  
				puts "link created"
				File.symlink source, target
			end  
		end

    def destroy
        FileUtils.rm_ft @resource[:path]
    end

    def exists?
				#
        #File.exists?(@resource[:path])
    end
end
