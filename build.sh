from __future__ import with_statement
from fabric.api import *
import sys
import jprops
import collections

with open('/opt/wfx-deploy/fabfile.properties') as fp:
  prop = jprops.load_properties(fp, collections.OrderedDict)

#env setting
env.roledefs = {
  'dev_puppet': ['172.31.28.3'],
  'prod_puppet': ['54.172.137.13'],

  'dev-east-wte': [prop['dev-east-wte']],
  'dev-east-wfxmc': [prop['dev-east-wfxmc']],
  'dev-east-brandfx': [prop['dev-east-brandfx']],
  'dev-east-tws': [prop['dev-east-tws']],
  'dev-east-analytics': [prop['dev-east-analytics']],
  'dev-east-brandnetworks': [prop['dev-east-brandnetworks']],

  'dev-east1-wte': [prop['dev-east1-wte']],
  'dev-east1-wfxmc': [prop['dev-east1-wfxmc']],
  'dev-east1-brandfx': [prop['dev-east1-brandfx']],
  'dev-east1-tws': [prop['dev-east1-tws']],
  'dev-east1-analytics': [prop['dev-east1-analytics']],

  'qa-east-wte': [prop['qa-east-wte']],
  'qa-east-wfxmc': [prop['qa-east-wfxmc']],
  'qa-east-brandfx': [prop['qa-east-brandfx']],
  'qa-east-tws': [prop['qa-east-tws']],
  'qa-east-analytics': [prop['qa-east-analytics']],
  'qa-east-brandnetworks': [prop['qa-east-brandnetworks']],
  
  'qa-east1-wte': [prop['qa-east1-wte']],
  'qa-east1-wfxmc': [prop['qa-east1-wfxmc']],
  'qa-east1-brandfx': [prop['qa-east1-brandfx']],
  'qa-east1-tws': [prop['qa-east1-tws']],
  'qa-east1-analytics': [prop['qa-east1-analytics']],

  'staging-east-wte': [prop['staging-east-wte']],
  'staging-east-wfxmc': [prop['staging-east-wfxmc']],
  'staging-east-brandfx': [prop['staging-east-brandfx']],
  'staging-east-tws': [prop['staging-east-tws']],
  'staging-east-analytics': [prop['staging-east-analytics']],
  'staging-east-brandnetworks': [prop['staging-east-brandnetworks']],

  'staginglive-east-wte': [prop['staginglive-east-wte']],
  'staginglive-east-wfxmc': [prop['staginglive-east-wfxmc']],
  'staginglive-east-brandfx': [prop['staginglive-east-brandfx']],
  'staginglive-east-tws': [prop['staginglive-east-tws']],
  'staginglive-east-analytics': [prop['staginglive-east-analytics']],
}

env.user = 'root'
env.key_filename = '/opt/wfx-deploy/.ssh/id_rsa'
env.port = 2020

#env.skip_bad_hosts=True
def copy_config(pkg,version,app_folder):
  folder = "wfx_deployment"
  run("rm -rf /etc/puppet/modules/%s/files/%s/%s;true" %(folder,pkg,version))
  run("mkdir -p /etc/puppet/modules/%s/files/%s/%s" %(folder,pkg,version))
  if not app_folder:
    put("/opt/wfx-software/%s/%s/config" %(pkg,version), "/etc/puppet/modules/%s/files/%s/%s/" %(folder,pkg,version))
  else:
    put("/opt/wfx-software/%s/%s/config/%s" %(pkg,version,app_folder), "/etc/puppet/modules/%s/files/%s/%s/" %(folder,pkg,version))
    

def copy_property_file(version,*args):
  for pkg in args:
    print pkg 

    if pkg == "wfxmc":
      copy_config(pkg,version,pkg)

    elif pkg == "wfxmc":
      copy_config(pkg,version,pkg)

    elif pkg == "twitterHost":
      copy_config(pkg,version,"twitterHost")

    elif pkg == "matchtable":
      copy_config(pkg,version,pkg) 

    else:
      copy_config(pkg,version,"") 

       
def pkg_version(param,version,path,env,pkg):
  run("sed -i 's/.*%s.*/%s %s/' %s/%s/%s.yaml" %(param,param,version,path,env,prop['%s-%s' %(env,pkg)]))

def pkg_version_one(param,version,path,env,prop):
  run("sed -i 's/.*%s.*/%s %s/' %s/%s/%s.yaml" %(param,param,version,path,env,prop))

  
def set_deploy_version(env,version,*args):
  path="/etc/puppet/hieradata/environment"
  for pkg in args:
    print pkg
    if pkg == "tws":
      param = "tws::version:"
      pkg_version(param,version,path,env,pkg)

    if pkg == "twsanalytics":
      param = "twsanalytics::version:"
      pkg_version_one(param,version,path,env,prop['%s-analytics' %env])

    if pkg == "ta":
      param = "ta::version:"
      pkg_version_one(param,version,path,env,prop['%s-analytics' %env])
    
    if pkg == "brandnetworks":
      param = "brandnetworks::version:"
      pkg_version_one(param,version,path,env,prop['%s-brandnetworks' %env])
 
    if pkg == "wte-brandnetworks":
      param = "wte::version:"
      pkg_version_one(param,version,path,env,prop['%s-brandnetworks' %env])
 
    if pkg == "wfx-reports":
      param = "wfx-reports::version:"
      pkg_version_one(param,version,path,env,prop['%s-analytics' %env])
   
    if pkg == "wfx-tcm":
      param = "wfx-tcm::version:"
      pkg_version_one(param,version,path,env,prop['%s-brandfx' %env])
   

    if pkg == "wfx-cable":
      param = "wfx-cable::version:"
      pkg_version_one(param,version,path,env,prop['%s-brandfx' %env])

    if pkg == "wfx-matchtable":
      param = "wfx-matchtable::version:"
      pkg_version_one(param,version,path,env,prop['%s-analytics' %env])
 
    if pkg == "wfxmc":
      param = "wfxmc::version:"
      pkg_version(param,version,path,env,pkg)

    if pkg == "utils":
      param = "util::version:"
      pkg_version_one(param,version,path,env,prop['%s-wte' %env])
      pkg_version_one(param,version,path,env,prop['%s-brandfx' %env])
      pkg_version_one(param,version,path,env,prop['%s-analytics' %env])
      pkg_version_one(param,version,path,env,prop['%s-wfxmc' %env])
    
    if pkg == "twitterhost":
      param = "twitterhost::version:"
      pkg_version_one(param,version,path,env,prop['%s-brandfx' %env])
    
    if pkg == "twitteranalytics":
      param = "twitteranalytics::version:"
      pkg_version_one(param,version,path,env,prop['%s-analytics' %env])

    if pkg == "matchtable":
      param = "matchtable::version:"
      pkg_version_one(param,version,path,env,prop['%s-analytics' %env])

    if pkg == "wte":
      param = "wte::version:"
      pkg_version(param,version,path,env,pkg)
    
    if pkg == "jCable":
      param = "jcable::version:"
      pkg_version_one(param,version,path,env,prop['%s-brandfx' %env])

    if pkg == "wte-brandfx":
      param = "wte::version:"
      pkg_version_one(param,version,path,env,prop['%s-brandfx' %env])
        
    if pkg == "referencedb":
      param = "referencedb::version:"
      pkg_version_one(param,version,path,env,prop['%s-analytics' %env])
def puppet_apply_module(project):
  """
  Apply Puppet manifest
  """
  with settings(warn_only=True):  
    result = run('puppet agent -t --server ip-172-31-28-3.ec2.internal --tags %s' %project)
    if result.return_code == 0:
      print "Client is up to date."
      sys.exit(0)
    if result.return_code == 1:
      print "Puppet couldn't compile the manifest."
      sys.exit(1)
    if result.return_code == 2:
      print "Puppet made Changes."
      sys.exit(0)
    if result.return_code == 4:
      print "Puppet Found Error."
      sys.exit(4)
    if result.return_code == 6:
      print "Puppet Found Error."
      sys.exit(4)
[root@Dev_East_Jenkins wfx-deploy]# 
