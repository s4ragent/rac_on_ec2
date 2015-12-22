export ANSIBLE_HOST_KEY_CHECKING=False
export ANSIBLE_LOG_PATH=/tmp/ansible
keypath=/home/ec2-user/oregon1503.pem
source common.sh

ansible-playbook -i hosts terminateRAC.yaml --private-key=$keypath -vvv
