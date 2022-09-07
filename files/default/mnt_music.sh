sudo mkdir /mnt/music
if [ ! -d "/etc/smbcredentials" ]; then
sudo mkdir /etc/smbcredentials
fi
if [ ! -f "/etc/smbcredentials/butlersa.cred" ]; then
    sudo bash -c 'echo "username=butlersa" >> /etc/smbcredentials/butlersa.cred'
    sudo bash -c 'echo "password=ZBqqVpmQ2Wz7Lupa4ic0C2VdRNxCyJUzfA3MsPsW8T1WayIX2WBMO/ft0A0PoLQMsXMKdmoNZp1D+LrW+IToXw==" >> /etc/smbcredentials/butlersa.cred'
fi
sudo chmod 600 /etc/smbcredentials/butlersa.cred

sudo bash -c 'echo "//butlersa.file.core.windows.net/music /mnt/music cifs nofail,credentials=/etc/smbcredentials/butlersa.cred,dir_mode=0777,file_mode=0777,serverino,nosharesock,actimeo=30" >> /etc/fstab'
sudo mount -t cifs //butlersa.file.core.windows.net/music /mnt/music -o credentials=/etc/smbcredentials/butlersa.cred,dir_mode=0777,file_mode=0777,serverino,nosharesock,actimeo=30