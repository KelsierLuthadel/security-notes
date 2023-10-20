# TLS Certificates
Transport Layer Security (TLS) certificates are essential to securing internet browser connections and transactions through data encryption.

In most cases, a Certificate Applicant will:
- Create a self-signed certificate
- Submit a Certificate Signing Request (CST) to a Certificate Authority (CA)
- Retrieve a TLS certificate that has been signed with the CA's private key


## Generate a CSR
Generate a private key, along with a Certificate Signing Request (CSR)

```bash
# Create a new private key using the RSA algorithm with a 2048 bit key length without using a passphrase (-nodes)

openssl req -new -newkey rsa:2048 -nodes -keyout server.key -out server.csr
```

```
You are about to be asked to enter information that will be incorporated
into your certificate request.
What you are about to enter is what is called a Distinguished Name or a DN.
There are quite a few fields but you can leave some blank
For some fields there will be a default value,
If you enter '.', the field will be left blank.
-----
Country Name (2 letter code) [AU]: UK
State or Province Name (full name) [Some-State]: London
Locality Name (eg, city) []: London
Organization Name (eg, company) [Internet Widgits Pty Ltd]: Kelsier
Organizational Unit Name (eg, section) []: Development
Common Name (e.g. server FQDN or YOUR name) []: public-server.com
Email Address []: admin@public-server.com

Please enter the following 'extra' attributes
to be sent with your certificate request
A challenge password []:
An optional company name []:
```

Two files will be created:
- *server.csr* - The Certificate Signing Request (CSR)
- *server.key* - The private key

**Important**: Ensure that the private key is stored in a secure location that only the owner of the key can access.


## Order TLS certificate
1. Open the csr file
1. Copy the text in it's entirety 
1. Submit the Certificate Signing Request
1. Obtain a signed TLS certificate

## Reverse Proxy
A reverse proxy, such as NGINX will accept a signed TLS certificate to take the burden away from a web server. After a TLS certificate has been issues, it can be installed on the server where the CSR was generated.

### Primary and Intermediate Certificates
If you have received a signed certificate in the format of `domain-name.pem`, then this .pem file contains both the primary certificate and the intermediate certificate. In this case, the certificate can be used directly in the proxy configuration. Otherwise, your primary certificate (`domain-name.crt`) will need to be concatenated with the issued intermediate certificate (`ProviderCA.crt`)

### Concatenating Primary and Intermediate Certificates
To concatenate your primary certificate (`domain-name.crt`) with the intermediate certificate (`ProviderCA.crt`), run:

```
cat domain-name.crt ProviderCA.crt > budle.pem
```

### NGINX Configuration
In the NGINX virtual hosts file, add the `ssl_certificate` lines as below

```
server {

  listen   443;

  ssl    on;
  ssl_certificate      /etc/ssl/domain-name.pem; (or bundle.crt)
  ssl_certificate_key  /etc/ssl/server.key;

  server_name your.domain.com;
  access_log /var/log/nginx/nginx.vhost.access.log;
  error_log /var/log/nginx/nginx.vhost.error.log;
  ...
} 
```