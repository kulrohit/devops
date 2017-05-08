require 'fileutils'
require 'net/http'
require 'uri'	

Puppet::Type.type(:deployment).provide(:deployer) do
  desc "Normal Unix-like POSIX support for file management."
	
  def create
    if @resource[:app_name] == "abcd" 
      repodownload
      create_symlink    
    else  
	    remove_folder
	    extract if repodownload
      create_symlink   
    end       
  end

  def destroy
    #File.unlink(@resource[:name])
  end

  def exists?
    #File.exists?(@resource[:name])
  end


  def remove_folder
    dir = @resource[:install_path] + "/" + @resource[:version]
	  FileUtils.rmtree dir if File.directory? dir
  end		
		
  def repodownload
	  uri = URI(@resource[:repo_url])
	  username = "deployment-release"
	  password = "deployment-release"

	  http = Net::HTTP.new(uri.host, uri.port)
	  request = Net::HTTP::Get.new(uri.request_uri)
		http.use_ssl = true
	  request.basic_auth(username, password)
	  response = http.request(request)
	  if response.code == "200"
	    puts "Downloading......\n #{uri}"
      open @resource[:full_path], 'wb' do | io | io.write response.read_body end
	    puts "Downloading Done."
      true
	  else
      fail("Check Url: #{@resource[:repo_url]}")
	    false
	  end
  end

  def extract 	
	  file = @resource[:full_path]
	  path = @resource[:install_path]
    own = @resource[:folder_owner]
	  if file.end_with? "gz"
	    command = "gunzip -t #{file}"
      system(command)
	    if $?.to_i != 0
	      fail "Broken file"
	    else
        puts "Extracting...\n #{file}"
	      command = "tar -zxf #{file} -C #{path}; chown -R #{own}:#{own} #{path}" 
	      system(command)
        puts "Extracted with command : '#{command}'"
	    end      
    end  

	  if file.end_with? "tar"
	    command = "tar -tf #{file}"
      system(command)
	      if $?.to_i == 0
          puts "Extracting...\n #{file}"
	        command = "tar -xf #{file} -C  #{path};chown -R #{own}:#{own} #{path}"
	        system(command)
          puts "Extracted with command : '#{command}'"
	      else
	        fail "Broken file"
	      end   
    end 
    File.unlink file  
  end

  def create_symlink
    dir = @resource[:install_path] + "/" + @resource[:version]
    target = @resource[:symlink]
    if File.symlink? target
      puts "Recreated symlink : #{target}"
      File.unlink target
      File.symlink dir, target
    else  
      puts "#{target} symlink created"
      File.symlink dir, target
    end  
  end
end
