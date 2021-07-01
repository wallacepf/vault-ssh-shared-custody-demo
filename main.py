import random
import string
import hvac
import os

characters = string.ascii_letters + string.digits + string.punctuation
password = ''.join(random.choice(characters) for i in range(32))

a, b = password[:len(password)//2], password[len(password)//2:]
print(f"Senha: {password}\nSenha user1: {a}\nSenha user2: {b}")

client = hvac.Client()

client.auth.approle.login(
    role_id=os.environ['ROLE_ID'],
    secret_id=os.environ['SECRET_ID']
)

client.secrets.kv.v2.create_or_update_secret(
    path='itau/user1',
    secret=dict(senha=a)
)

client.secrets.kv.v2.create_or_update_secret(
    path='itau/user2',
    secret=dict(senha=b)
)
