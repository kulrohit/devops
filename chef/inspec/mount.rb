 control 'V-V' do
  impact 0.5
  title 'V-ccccc4087: User start-up files must not execute world-writable programs.'
  desc '-up files execute world-writable programs, especially in unprotected directories, they could be maliciously modified to become trojans that destroy user files or otherwise compromise the system at the user, or higher, level.  If the system is compromised at the user level, it is much easier to eventually compromise the system at the root and network level.'

  cmd=<<-EOH
		env=`uname -n | awk '{print substr($1,2,1)}'`
		if [ $env == h ]
			then
               umount /vol/uhome_dev
		                                              
		elif [$env != h ]
			then umount /vol/uhome
				
			fi
  EOH


describe command(cmd) do
    its(:stdout) { should eq '' }
  end
end
