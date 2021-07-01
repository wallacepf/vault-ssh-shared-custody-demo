#!/bin/bash

### Use Case - One Time Password
vault auth enable userpass
vault secrets enable ssh

vault write ssh/roles/otp_key_role key_type=otp default_user=demo cidr_list=0.0.0.0/0

vault policy write test ./ssh.hcl

vault write auth/userpass/users/test-otp password="123abc" policies="test"