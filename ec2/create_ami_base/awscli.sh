
createsnapshot()
{
  InstanceId=$1
  DeviceName=$2
  Region=$3
  #VolumeId=`aws ec2 describe-volumes --region $Region --query "Volumes[].Attachments[][?Device==\\\`$DeviceName\\\`][?InstanceId==\\\`$InstanceId\\\`].VolumeId" --output text`
  VolumeId=`aws ec2 describe-volumes --region $Region --filters "Name=attachment.instance-id,Values=$InstanceId" "Name=attachment.device,Values=$DeviceName" --query "Volumes[].Attachments[].VolumeId" --output text`
  SnapshotId=`aws ec2 create-snapshot --region $Region --volume-id $VolumeId --query 'SnapshotId' --output text`
  State=`aws ec2 describe-snapshots --region $Region --snapshot-ids $SnapshotId --query 'Snapshots[].State[]' --output text`
  while [ $State = "pending" ]
  do
    sleep 10
    State=`aws ec2 describe-snapshots --region $Region --snapshot-ids $SnapshotId --query 'Snapshots[].State[]' --output text`
  done
  echo $SnapshotId
}

createimage(){
snapid=`createsnapshot $1 $2 $3`
cat > blockdevice.json <<EOF
[
        {"DeviceName":"/dev/xvda","Ebs":{"VolumeType":"gp2","DeleteOnTermination":true,"SnapshotId":"$snapid"}}
]
EOF

DATE=`date "+%Y%m%d%H%M"`
amiid=`aws ec2 register-image --region $3 --root-device-name /dev/xvda --name "Oracle linux6 Latest $DATE" --block-device-mappings file://blockdevice.json --virtualization-type hvm --architecture x86_64 --description "Oracle Linux 6 Latest" --output text`
rm -rf blockdevice.json
rm -rf -
sleep 30
echo $amiid
}

case "$1" in
"createsnapshot" ) shift;createsnapshot $*;;
"createimage" ) shift;createimage $*;;
esac
