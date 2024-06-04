# Install TF Debian 12

- [Hashicorp TF Install](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli)

1. Corregir el archivo del repositorio
-	```shell
 	vim /etc/apt/sources.list.d/hashicorp.list
   	```
-	```shell
	deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com bookworm main
  	```

2. Ensure your system have installed the gnupg, software-properties-common, and curl packages installed.
-	```shell
	sudo apt-get update && sudo apt-get install -y gnupg software-properties-common
   	```

3. Install the HashiCorp GPG key.
-	```shell
	wget -O- https://apt.releases.hashicorp.com/gpg | \
	gpg --dearmor | \
	sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg > /dev/null
	```
4. Verify the key's fingerprint.
-	```shell 
	gpg --no-default-keyring \
	--keyring /usr/share/keyrings/hashicorp-archive-keyring.gpg \
	--fingerprint
	```

5. The gpg command will report the key fingerprint:
-	```shell
	/usr/share/keyrings/hashicorp-archive-keyring.gpg-------------------------------------------------pub   rsa4096 XXXX-XX-XX [SC]AAAA AAAA AAAA AAAAuid           [ unknown] HashiCorp Security (HashiCorp Package Signing) <security+packaging@hashicorp.com>sub   rsa4096 XXXX-XX-XX [E]
	```

6. Add the official HashiCorp repository to your system. The lsb_release -cs command finds the distribution release codename for your current system, such as buster, groovy, or sid.
-	```shell
	echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] \
	https://apt.releases.hashicorp.com $(lsb_release -cs) main" | \
	sudo tee /etc/apt/sources.list.d/hashicorp.list
	```

7. Download the package information from HashiCorp.
-	```shell
	sudo apt update
 	```

8. Install Terraform from the new repository.
-	```shell
	sudo apt-get install terraform
	```

# Install AWS CLI
- [AWS CLI Install](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html)

1.	```shell
	sudo apt update
	sudo apt install -y unzip curl
	```
2.	```shell
	curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
	unzip awscliv2.zip
	sudo ./aws/install
	```
3.
	```shell
	aws --version
	aws configure

	```
