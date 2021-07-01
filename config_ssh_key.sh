#!/bin/bash

### Use Case - SSH Keys
vault auth enable userpass
vault secrets enable -path=ssh-client-signer ssh

vault write ssh-client-signer/config/ca generate_signing_key=true
vault write ssh-client-signer/roles/my-role @my_role_ssh_key.json
vault policy write ssh-key ./ssh_key.hcl
vault write auth/userpass/users/test-ssh-key password="123abc" policies="ssh-key"

