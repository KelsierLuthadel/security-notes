# GPG Basics

## Create a Key Pair
To generate a new key pair use the `--full-gen-key`, this will walk you through an interactive prompt that will ask you questions about the type of key and your details.

```bash
$ gpg --full-gen-key
```

## Export Private Key
You will want to export your private key and store it somewhere safe, such as a vault. This key should not be made public, and if it is stored on a filesystem then this key will need to be protected so that only you can view it.

`gpg --export-secret-keys --armor <private key ID >`

```bash
# Find the ID of your private key
$ gpg --list-secret-keys

$ gpg --export-secret-keys --armor ABCDEF01234567890 > ./my-priv-gpg-key.asc
```

## Delete a Key
You can delete a public or private key from local storage by using

```bash
# Delete a private key
$ gpg --delete-secret-keys ABCDEF01234567890

# Delete a public key
$ gpg --delete-keys ABCDEF01234567890

```

## Export Public Key
`gpg --export --armor --output <key> <user-id>`

```bash
$ gpg --export --armor --output public-key.asc ABCDEF0123456789
```

## List Public Keys

```bash
$ gpg --list-keys
```

## List Private Keys

```bash
$ gpg --list-secret-keys
```

## Register key with a Public PGP Key Server
`gpg --send-keys --keyserver <server> <key-id>`

```bash
$ gpg --send-keys --keyserver pgp.mit.edu ABCDEF0123456789
```

## Import a key
you can to import a key, such as:
- A backup key you have already made
- A public key from someone, but don't implicitly trust
- A public key from you know, and implicitly trust

`gpg --import <public key>`

```bash
# Import a public key from a file
$ gpg --import public.key

# Import a public key from a server
$ gpg --keyserver pgp.mit.edu  --recv 01234567890ABCDEF
```

## Trusting a key
By default, when you import a public key, the trust status is set to `unknown`. You can edit a public key and change the level of trust.

`gpg --edit-key <recipient> <key>`

```bash
$ gpg --edit-key kelsier public.key
```

This will bring you to an interactive shell, whereby you can change the status of the public key.

```
gpg (GnuPG) 2.2.40; Copyright (C) 2022 g10 Code GmbH
This is free software: you are free to change and redistribute it.
There is NO WARRANTY, to the extent permitted by law.

gpg> trust
```

## Encrypt a file
There are two types of encryption, symmetric and asymmetric. GPG supports various types of encryption methods for each algorithm, the most common ones are:
- AES of symmetric
- RSA of asymmetric
- ECDSA for asymmetric (this is starting to replace RSA)


### Symmetric Encryption with a Passphrase
This can be decrypted by anyone with a passphrase (no specific recipient). The passphrase can be shared.

```bash
# Prompt for a passphrase, and create a binary file (filename.txt.gpg)
$ gpg --symmetric message.txt

# Prompt for a passphrase, and create an ASCII file suitable for email (filename.txt.asc)
$ gpg --symmetric --armor  message.txt

# Specify the encryption algorithm
$ gpg --symmetric --cipher-algo AES256 message.txt

# Specify output file
$ gpg --symmetric --output message.txt.gpg message.txt

# Encrypt and sign
$ gpg --symmetric --sign  message.txt
```

### Asymmetric Encryption
You can encrypt a message for a specified recipient. This will encrypt the file asymmetrically with your private key, and the recipients public key. Only the recipients private key will be able to decrypt the message.

```bash
# Specify the recipient name
$ gpg --encrypt --recipient 'Recipient name' filename.txt

# Specify multiple recipients
$ gpg --encrypt --recipient 'user@example.com' --recipient 'Kelsier' filename.txt

# Specify the encryption algorithm
$ gpg --encrypt --recipient 'Kelsier' --symmetric --cipher-algo AES256  filename.txt

# Output the encrypted message as ASCII
$ gpg --encrypt --armor --recipient 'Kelsier' --output filename.asc filename.txt
```

## Sign a file
You can sign files using both symmetric and asymmetric methods. This benefit of providing a signature is that it lets everyone know that you are the author of the file (non-repudiation).

You can also just sign files without encrypting them at all.

```bash
# Outputs message.txt.asc in plain text, suitable for pasting in an email 
$ gpg --clearsign message.txt
$ gpg --sign --armor message.txt

# Outputs message.txt.gpg a binary file
$ gpg --sign message.txt
```

## Sign and Encrypt
You can both encrypt and sign a message in a single step. This will attach a signature to the encrypted file.

```bash
# Symmetric encrypt with signature
$ gpg --sign --symmetric message.txt

# Asymmetric encrypt with signature
$ gpg --sign --encrypt --recipient nanodano@devdungeon.com message.txt
```

## Verify Signatures
If a signature is included in the encrypted file, GPG will automatically verify the signature during decryption. However, you can also manually verify a signature for non-repudiation checks.

```bash
# Verify a signed message that included a signature
$ gpg --verify message.txt.asc

# Verify and extract original document
$gpg --output message.txt message.txt.asc
```

## Decrypt a file
When decrypting a file, GPG will automatically determine the encryption method. If it is symmetrically encrypted, then GPG will prompt for a passphrase. If it is asymmetrically encrypted, then GPG will look for your private key.

`gpg --decrypt <file>`

```bash
$ gpg --decrypt encrypted.gpg
$ gpg --decrypt encrypted.gpg > plaintext
```


## Generate Revocation Key
`$ gpg --gen-revoke user-id --output <cert>`

```bash
$ gpg --gen-revoke ABCDEF0123456789 --output revocation.crt
$ chmod 600 revocation.crt
```


