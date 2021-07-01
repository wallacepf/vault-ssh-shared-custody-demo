# Vault Demo

Requirements

Start Vault Server in dev mode

```bash
vault server -dev -dev-listen-address=x.x.x.x:8200
```

*Once we're running these demos in dev mode, don't forget to set the VAULT_ADDR and VAULT_TOKEN env vars before you run the config.sh

## Use Cases

### Shared Custody 

Run config_custody.sh script:

```bash
chmod +x config.sh
./config_custody.sh
```

Get the AppRole ID

```bash
vault read auth/approle/role/my-role/role-id
```

Get the SecretID

```bash
vault write -f auth/approle/role/my-role/secret-id
```

Set the AppRole infos as environment variables

```bash
export ROLE_ID="<ROLEID>"
export SECRET_ID="<SECRETID>"
```

Run the python script:

```bash
python3 main.py
```

The output should be something similar to this:

```
Senha: CV[YH+%r5dHDtK]}:h,7G'ttWr1j]s/>
Senha user1: CV[YH+%r5dHDtK]}
Senha user2: :h,7G'ttWr1j]s/>
```

Check if user1 can access his part of the password:

```bash
vault login -method=userpass username=user1 password=123abc
vault kv get secret/itau/user1
```

Check if user1 can access user2's password:

```bash
vault kv get secret/itau/user2
```

Now, repeat this as user2.

### Linux One Time Password

Setup the and connect to linux machine for the lab using Vagrant:

```bash
vagrant up
vagrant ssh otp
```

Create a user for the demo:

```bash
sudo useradd demo
```

Follow the instructions to setup the vault-ssh-helper:

[Learn Vault - OTP](https://learn.hashicorp.com/tutorials/vault/ssh-otp?in=vault/interactive)

Configure OTP on Vault:

```bash
chmod +x config_otp.sh
./config_otp.sh
```

Login with test-otp account

```bash
vault login -method=userpass username=test-otp password=123abc
```

Generate OTP Password for the configured user

```bash
vault write ssh/creds/otp_key_role ip=<host_ip>
```

Connect to the target host using the provided key:

```bash
ssh demo@127.0.0.1 -p 2200
```

### Linux SSH Key Connection

Configure SSH Key on Vault:

```bash
chmod +x config_ssh_key.sh
./config_ssh_key.sh
```

On Linux Machine, get the public key using an API Call:

```bash
sudo curl -o /etc/ssh/trusted-user-ca-keys.pem http://<vault_addr>:8200/v1/ssh-client-signer/public_key
```

Restart the SSH Service

```bash
sudo service sshd restart
```

Back on client, login as test-ssh-key user:

```bash
vault login -method=userpass usename=test-ssh-key password=123abc
```

Ask Vault to sign your public key:

```bash
vault write ssh-client-signer/sign/my-role \
   public_key=@$HOME/.ssh/id_rsa.pub
```

Save the signed public key to disk:

```bash
vault write -field=signed_key ssh-client-signer/sign/my-role \
    public_key=@$HOME/.ssh/id_rsa.pub > signed-cert.pub
```

Connet to the target host:
```bash
ssh -i signed-cert.pub -i ~/.ssh/id_rsa demo@127.0.0.1 -p 2201
```