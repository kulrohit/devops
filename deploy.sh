#!/bin/bash
cd /opt/wfx-deploy
usage(){
   echo "Usage deploy.sh environment, version, compoments"
   echo "componenets are wte,twitterhost,wfxmc,ta,wfxutil,tws"
   echo "environments are dev-east,qa-east,dev-east1,qa-west,staging-east,staginglive-east"
   exit 1  
}

if [ "$#" -lt 3 ]; then
  usage
fi

#Branch name from arguments. First Argument is branch name
environment=$1
shift
version=$1
shift
#all arguments
pkgs=( "$@" )

echo $environment
echo $version
for pkg in "${pkgs[@]}"
 do
   case "$pkg" in
   wfxmc) 
      fab -R dev_puppet copy_property_file:${version},${pkg} || exit 1
      fab -R dev_puppet set_deploy_version:${environment},${version},${pkg} || exit 1
      fab -R ${environment}-${pkg} puppet_apply_module:wfx_deployment::${pkg} || exit 1
    ;;

   twitterhost) 
      fab -R dev_puppet copy_property_file:${version},${pkg} || exit 1 
      fab -R dev_puppet set_deploy_version:${environment},${version},${pkg}|| exit 1
      fab -R ${environment}-brandfx puppet_apply_module:wfx_deployment::${pkg}|| exit 1
    ;;
   
    twitteranalytics) 
      fab -R dev_puppet copy_property_file:${version},${pkg} || exit 1 
      fab -R dev_puppet set_deploy_version:${environment},${version},${pkg}|| exit 1
      fab -R ${environment}-analytics puppet_apply_module:wfx_deployment::${pkg}|| exit 1
    ;;
   
    matchtable) 
      fab -R dev_puppet copy_property_file:${version},${pkg} || exit 1
      fab -R dev_puppet set_deploy_version:${environment},${version},${pkg}|| exit 1
      fab -R ${environment}-analytics puppet_apply_module:wfx_deployment::${pkg}|| exit 1
    ;;
    
   wte)
      fab -R dev_puppet copy_property_file:${version},${pkg} || exit 1 
      fab -R dev_puppet set_deploy_version:${environment},${version},${pkg} || exit 1
      fab -R ${environment}-${pkg} puppet_apply_module:wfx_deployment::${pkg} || exit 1
      fab -R ${environment}-${pkg} puppet_apply_module:wfx_deployment::${pkg}_config || exit 1
    ;;
  
   jCable)
      fab -R dev_puppet copy_property_file:${version},${pkg} || exit 1 
      fab -R dev_puppet set_deploy_version:${environment},${version},${pkg} || exit 1
      fab -R ${environment}-brandfx puppet_apply_module:wfx_deployment::jcable || exit 1
    ;;

   wfx-cable)
      fab -R dev_puppet copy_property_file:${version},${pkg} || exit 1
      fab -R dev_puppet set_deploy_version:${environment},${version},${pkg} || exit 1
      fab -R ${environment}-brandfx puppet_apply_module:wfx_deployment::wfx-cable || exit 1
    ;;

   wte-brandfx)  
      fab -R dev_puppet copy_property_file:${version},${pkg} || exit 1 
      fab -R dev_puppet set_deploy_version:${environment},${version},${pkg} || exit 1
      fab -R ${environment}-brandfx puppet_apply_module:wfx_deployment::wte || exit 1
      fab -R ${environment}-brandfx puppet_apply_module:wfx_deployment::wte_cable_config || exit 1
      fab -R ${environment}-brandfx puppet_apply_module:wfx_deployment::wte_tch_config || exit 1
    ;;

   ta)
      fab -R dev_puppet copy_property_file:${version},${pkg} || exit 1 
      fab -R dev_puppet set_deploy_version:${environment},${version},${pkg} || exit 1
      fab -R ${environment}-analytics puppet_apply_module:wfx_deployment::${pkg} || exit 1
    ;;

   brandnetworks)
      fab -R dev_puppet copy_property_file:${version},${pkg} || exit 1 
      fab -R dev_puppet set_deploy_version:${environment},${version},${pkg} || exit 1
      fab -R ${environment}-brandnetworks puppet_apply_module:wfx_deployment::${pkg} || exit 1
    ;;
   
   referencedb)
      fab -R dev_puppet copy_property_file:${version},${pkg} || exit 1 
      fab -R dev_puppet set_deploy_version:${environment},${version},${pkg} || exit 1
      fab -R ${environment}-analytics puppet_apply_module:wfx_deployment::${pkg} || exit 1
    ;;

   wte-brandnetworks)
      fab -R dev_puppet copy_property_file:${version},wte || exit 1 
      fab -R dev_puppet set_deploy_version:${environment},${version},wte-brandnetworks || exit 1
      fab -R ${environment}-brandnetworks puppet_apply_module:wfx_deployment::wte || exit 1
      fab -R ${environment}-brandnetworks puppet_apply_module:wfx_deployment::wte_config || exit 1
    ;;

   wfx-reports)
      fab -R dev_puppet copy_property_file:${version},${pkg} || exit 1 
      fab -R dev_puppet set_deploy_version:${environment},${version},${pkg} || exit 1
      fab -R ${environment}-analytics puppet_apply_module:wfx_deployment::${pkg} || exit 1
    ;;

   wfx-tcm)
      fab -R dev_puppet copy_property_file:${version},${pkg} || exit 1 
      fab -R dev_puppet set_deploy_version:${environment},${version},${pkg} || exit 1
      fab -R ${environment}-brandfx puppet_apply_module:wfx_deployment::${pkg} || exit 1
    ;;

   wfx-cable)
      fab -R dev_puppet copy_property_file:${version},${pkg} || exit 1 
      fab -R dev_puppet set_deploy_version:${environment},${version},${pkg} || exit 1
      fab -R ${environment}-brandfx puppet_apply_module:wfx_deployment::${pkg} || exit 1
    ;;

   wfx-matchtable)
      fab -R dev_puppet copy_property_file:${version},${pkg} || exit 1 
      fab -R dev_puppet set_deploy_version:${environment},${version},${pkg} || exit 1
      fab -R ${environment}-analytics puppet_apply_module:wfx_deployment::${pkg} || exit 1
    ;;

   tws)
      fab -R dev_puppet copy_property_file:${version},${pkg} || exit 1
      fab -R dev_puppet set_deploy_version:${environment},${version},${pkg}|| exit 1
      fab -R ${environment}-${pkg} puppet_apply_module:wfx_deployment::${pkg}|| exit 1
    ;;

   twsanalytics)
      fab -R dev_puppet copy_property_file:${version},${pkg} || exit 1
      fab -R dev_puppet set_deploy_version:${environment},${version},${pkg}|| exit 1
      fab -R ${environment}-analytics puppet_apply_module:wfx_deployment::${pkg}|| exit 1
    ;;

   utils)
      fab -R dev_puppet set_deploy_version:${environment},${version},${pkg} || exit 1
      fab -R ${environment}-wte puppet_apply_module:wfx_deployment::${pkg} || exit 1
      fab -R ${environment}-brandfx puppet_apply_module:wfx_deployment::${pkg} || exit 1
      fab -R ${environment}-analytics puppet_apply_module:wfx_deployment::${pkg} || exit 1
      fab -R ${environment}-wfxmc puppet_apply_module:wfx_deployment::${pkg} || exit 1
    ;;

   *)
     usage
    ;;
  esac

 done