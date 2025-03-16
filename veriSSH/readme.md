# Usage of verifySSHFingerprint

1. If you would like to run the script properly without `bash` command, please remember `chmod` the script with **`x`** privilege at the right group, **owner**, **group** or **other**.
1. The script needs to know:
> - the **hostname** or **ip address**
> - the **type of ssh keys**, for example, *Ed25519*, *rsa*, etc
> - the **fingerprint file** or **public key file**
> - Optionally, if the port is **not 22** as default, please list the port number out

3. An example:
> Don't forget the **`./`** before the name of the script
```bash
./verifySSHFingerprint.sh -h=192.168.1.156 -p=2229 -t=Ed25519 -ff=../fingerprint.txt
```

# Intruduction of verifySSHFingerprint

## Purpose of verifySSHFingerprint
**Before** logging in an SSH server, it would be good to compare the fingerprint of the public SSH key from the SSH server with the fingerprint for the SSH server via a secure channel.

## Working way of the comparison
> - Getting the fingerprint from the SSH server, via Command `ssh-keyscan` and `ssh-keygen`
> - Getting the fingerprint by reading the fingerprint file or getting the fingerprint by Command `ssh-keygen` converting the public key to the fingerprint