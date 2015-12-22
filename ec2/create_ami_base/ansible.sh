export ANSIBLE_HOST_KEY_CHECKING=False
#image : ami-5d356a6d
#Virginia: ami-d2166bba
#Oregon: ami-5a20b86a
#Tokyo: ami-c66b78c7
ansible-playbook -i inithosts create_base.yaml --private-key=/home/ec2-user/oregon1503.pem -e image=ami-5a20b86a -e group=launch-wizard-1 -e keypair=oregon1503 -e region=us-west-2 -vvv
