export ANSIBLE_HOST_KEY_CHECKING=False
export ANSIBLE_LOG_PATH=/tmp/ansible
keypath=/home/ec2-user/oregon1503.pem
source common.sh
bash common.sh createansiblehost $num_of_nodes 

#for normal_install_on_EFS
#ansible-playbook -f 64 -i hosts create_rac.yaml --private-key=$keypath -t "ec2_startup,preinstall,nfsclient,media,rsp,img,reboot,gridswinstall,orainventory,gridrootsh,asmca,dbswinstall,orarootsh,dbca,gridstatus" -vvv

#for clone_on_EFS
#ansible-playbook -f 32 -i hosts create_rac.yaml --private-key=$keypath -t "ec2_startup,preinstall,nfsclient,rsp,img,reboot,cleanGIDB,clonepl_startsh,gridstartsh,orainventory,configsh,gridrootsh,asmca,orastartsh,orarootsh,dbca,gridstatus" -vvv

#ansible-playbook -f 32 -i hosts create_rac.yaml --private-key=$keypath -t "vxlan_reload,configsh,gridrootsh,asmca,orastartsh,orarootsh,dbca,gridstatus" -vvv



#for simple task
ansible-playbook -i hosts create_rac.yaml --private-key=$keypath -t "dbca2" -vvv
