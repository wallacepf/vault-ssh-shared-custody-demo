$script1 = <<-SCRIPT

sudo apt-get upgrade
sudo apt-get update -y
sudo apt-get install unzip -y
wget https://releases.hashicorp.com/vault-ssh-helper/0.2.1/vault-ssh-helper_0.2.1_linux_amd64.zip
sudo unzip -q vault-ssh-helper_0.2.1_linux_amd64.zip -d /usr/local/bin
sudo chmod 0755 /usr/local/bin/vault-ssh-helper
sudo chown root:root /usr/local/bin/vault-ssh-helper
sudo mkdir /etc/vault-ssh-helper.d/
sudo useradd demo

VAULT_EXTERNAL_ADDR='http://<your_ip_address>:8200'

sudo tee /etc/vault-ssh-helper.d/config.hcl <<EOF
vault_addr = "$VAULT_EXTERNAL_ADDR"
tls_skip_verify = false
ssh_mount_point = "ssh"
allowed_roles = "*"
EOF

sudo cp /etc/pam.d/sshd /etc/pam.d/sshd.orig
sudo cp /etc/ssh/sshd_config /etc/ssh/sshd_config.orig

SCRIPT

$script2 = <<-SCRIPT
sudo curl -o /etc/ssh/trusted-user-ca-keys.pem http://<your_ip_address>:8200/v1/ssh-client-signer/public_key
sudo echo "TrustedUserCAKeys /etc/ssh/trusted-user-ca-keys.pem" >> /etc/ssh/sshd_config
sudo useradd demo
SCRIPT

Vagrant.configure("2") do |config|

  config.vm.define "otp" do |otp|
    otp.vm.box = "generic/debian10"

    otp.vm.provision "shell", inline: $script1

  end

  config.vm.define "ssh" do |ssh|
    ssh.vm.box = "generic/debian10"

    ssh.vm.provision "shell", inline: $script2
  end
end
