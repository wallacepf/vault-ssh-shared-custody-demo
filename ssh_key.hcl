# To list SSH secrets paths
path "ssh-client-signer/*" {
  capabilities = [ "list" ]
}
# To use the configured SSH secrets engine otp_key_role role
path "ssh-client-signer/sign/my-role" {
  capabilities = ["update"]
}