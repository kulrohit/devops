
require 'puppet/resource'
require 'puppet/resource/catalog'
require 'fileutils'
require 'rubygems'
require 'facter'

Puppet::Type.type(:extract).provide(:extract) do
    desc "extract tar or tgz"
		
    def create
			file = @resource[:name]
			path = @resource[:path]
			if file.end_with? "gz"
				command = "gunzip -t #{file}"
				system(command)
				if $?.to_i != 0
					fail "Broken file"
				else
					command = "tar -zxf #{file} -C #{path}" 
					system(command)
				end      
			end  

			if file.end_with? "tar"
				command = "tar -tf #{file}"
				system(command)
				if $?.to_i == 0
					command = "tar -xf #{file} -C  #{path}"
					system(command)
				else
					fail "Broken file"
				end   
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
