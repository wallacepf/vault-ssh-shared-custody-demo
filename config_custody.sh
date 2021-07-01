#!/bin/bash

### Use Case - Custodia Compartilhada
vault auth enable userpass
vault auth enable approle

vault write auth/approle/role/my-role secret_id_ttl=10m token_num_uses=10 token_ttl=60m token_max_ttl=120m secret_id_num_uses=40 policies=script

vault policy write user1 user1.hcl
vault policy write user2 user2.hcl
vault policy write script ./script.hcl

vault write auth/userpass/users/user1 password=123abc policies=user1
vault write auth/userpass/users/user2 password=123abc policies=user2

