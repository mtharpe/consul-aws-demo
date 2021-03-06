#!/bin/bash

export IP_ADDRESS=$(curl http://169.254.169.254/latest/meta-data/local-ipv4)

echo "Configuring user....."
sudo mkdir -p "/home/${username}/.cache"
sudo touch "/home/${username}/.cache/motd.legal-displayed"
sudo touch "/home/${username}/.sudo_as_admin_successful"
sudo chown -R "${username}:${username}" "/home/${username}"

echo "Configuring MOTD....."
sudo rm -rf /etc/motd
sudo rm -rf /var/run/motd
sudo rm -rf /etc/update-motd.d/*
sudo tee /etc/motd > /dev/null <<"EOF"
              
                    `..    `.`                    
                 `/smM/    :Mms/`                 
             `-ohNMMMM/    :MMMMm   `             
         `./ymMMMMMMNh-    :MMMMm   sy/.`         
        :dNMMMMMNms:.      :MMMMm   hMMNd:        
        +MMMMMh+-  ./y:    :MMMMm   hMMMM+        
        +MMMMd   +hNMM/    :MMMMm   hMMMM+        
        +MMMMd   mMMMM+....+MMMMm   hMMMM+        
        +MMMMd   mMMMMNNNNNNMMMMm   hMMMM+        
        +MMMMd   mMMMMMNNNNMMMMMm   hMMMM+        
        +MMMMd   mMMMMo----+MMMMm   hMMMM+        
        +MMMMd   mMMMM/    :MMNdo   hMMMM+        
        +MMMMd   mMMMM/    -y/.` -+yNMMMM+        
        :dMMMd   mMMMM/      `:sdNMMMMMMd:        
         `.+yy   mMMMM/    .hNMMMMMMmy+.`         
             `   mMMMM/    :MMMMNdo-`             
                 `/smM/    :Mmy/.                 
                    `..    `-`                    
                                                  
Hello ${namespace}! And yes, all demos should be done live.                                                
EOF

echo "Setting hostname....."
sudo tee /etc/hostname > /dev/null <<"EOF"
${hostname}
EOF
sudo hostname -F /etc/hostname
sudo tee -a /etc/hosts > /dev/null <<EOF
# For local resolution
$IP_ADDRESS  ${hostname}
EOF