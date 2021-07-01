path "secret/data/itau/user1" {
  capabilities = ["read", "list"]
}

path "kv-v2/data/shxxd0012cld/root"{
  capabilities = ["read", "list"]
}

vault write auth/userpass/users/meire password=123abc policies=meire