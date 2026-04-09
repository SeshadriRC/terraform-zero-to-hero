# Vault Integration

Here are the detailed steps for each of these steps:

## Create an AWS EC2 instance with Ubuntu

To create an AWS EC2 instance with Ubuntu, you can use the AWS Management Console or the AWS CLI. Here are the steps involved in creating an EC2 instance using the AWS Management Console:

- Go to the AWS Management Console and navigate to the EC2 service.
- Click on the Launch Instance button.
- Select the Ubuntu Server xx.xx LTS AMI.
- Select the instance type that you want to use.
- Configure the instance settings.
- Click on the Launch button.

## Install Vault on the EC2 instance

To install Vault on the EC2 instance, you can use the following steps:

[official-doc](https://developer.hashicorp.com/vault/install)

**Install gpg**

```
sudo apt update && sudo apt install gpg
```

**Download the signing key to a new keyring**

```
wget -O- https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
```

**Verify the key's fingerprint**

```
gpg --no-default-keyring --keyring /usr/share/keyrings/hashicorp-archive-keyring.gpg --fingerprint
```

**Add the HashiCorp repo**

```
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
```

```
sudo apt update
```

**Finally, Install Vault**

```
sudo apt install vault
```

<img width="1248" height="122" alt="image" src="https://github.com/user-attachments/assets/9ee05bf2-6ddc-483c-8cac-831eb66771d0" />


## Start Vault.

To start Vault, you can use the following command:

```
vault server -dev -dev-listen-address="0.0.0.0:8200"
```

<img width="1135" height="227" alt="image" src="https://github.com/user-attachments/assets/b254108b-cf83-4b35-9613-19724a4b4493" />

<img width="1529" height="373" alt="image" src="https://github.com/user-attachments/assets/f9f2284f-58a4-4da1-b057-6816be78f859" />



- Allow the inbound rule for 8200 port
- use the root token which shown in vault cli to login to the vault console

<img width="1919" height="1030" alt="image" src="https://github.com/user-attachments/assets/6749749c-f6cf-4f92-8968-72316dcafeb7" />

<img width="1919" height="978" alt="image" src="https://github.com/user-attachments/assets/9ed03fbe-ac59-4a09-a1aa-84aef126b413" />


## Create the Secret Engine using the vault console

- Enable new engine
<img width="1919" height="306" alt="image" src="https://github.com/user-attachments/assets/28f124f8-ee43-4bdf-856e-c47d365256cd" />

- Select KV
<img width="1919" height="395" alt="image" src="https://github.com/user-attachments/assets/21434d88-0369-4036-bfaa-b81ebbb155d1" />

- Enable engine
<img width="1918" height="693" alt="image" src="https://github.com/user-attachments/assets/3af597a9-b675-444a-853f-429df57aff4e" />

- Now we have created secret engine, next step is we need to create Secret inside that.
<img width="1917" height="727" alt="image" src="https://github.com/user-attachments/assets/37f9b40b-f63e-45cc-b9a4-059c30d994fc" />

- In below pic we can see key-value pairs
    - Path for this secret: `test-secret1`  --> nothing but name of the secret
    - secret data: `username` --> nothing but the key
    - value: `seshadri` --> nothing but the value
      
<img width="1918" height="782" alt="image" src="https://github.com/user-attachments/assets/2a3ee8e8-57d7-4a65-97de-a52d442e5de2" />


- Saved it.

<img width="1909" height="804" alt="image" src="https://github.com/user-attachments/assets/c28b7814-9d3f-4df2-a374-1017a37f757b" />
<img width="1919" height="829" alt="image" src="https://github.com/user-attachments/assets/d113e898-8f41-4d57-b75a-ae1b31f2b8dc" />
<img width="1917" height="556" alt="image" src="https://github.com/user-attachments/assets/3d91721b-30f8-4050-ba1a-11c8cc50c349" />


## Configure Terraform to read the secret from Vault.

Detailed steps to enable and configure AppRole authentication in HashiCorp Vault:

1. **Enable AppRole Authentication**:

To enable the AppRole authentication method in Vault, you need to use the Vault CLI or the Vault HTTP API.

**Using Vault CLI**:

Run the following command to enable the AppRole authentication method:

```bash
vault auth enable approle
```
<img width="1174" height="209" alt="image" src="https://github.com/user-attachments/assets/10e642f5-3a42-43e0-9c1d-3c16ff33ef6a" />
<img width="1857" height="445" alt="image" src="https://github.com/user-attachments/assets/42b1d7c4-0f48-4b53-ab12-760a6bba8d39" />

- App role is enabled
<img width="1919" height="553" alt="image" src="https://github.com/user-attachments/assets/f4aca539-7379-450d-a10b-68d3920eb48f" />


This command tells Vault to enable the AppRole authentication method.

2. **Create an AppRole**:

We need to create policy first,

```
vault policy write terraform - <<EOF
path "*" {
  capabilities = ["list", "read"]
}

path "secrets/data/*" {
  capabilities = ["create", "read", "update", "delete", "list"]
}

path "kv/data/*" {
  capabilities = ["create", "read", "update", "delete", "list"]
}


path "secret/data/*" {
  capabilities = ["create", "read", "update", "delete", "list"]
}

path "auth/token/create" {
capabilities = ["create", "read", "update", "list"]
}
EOF
```

<img width="912" height="428" alt="image" src="https://github.com/user-attachments/assets/012a10f7-60f9-43dc-955b-d8642db97d47" />
<img width="1919" height="838" alt="image" src="https://github.com/user-attachments/assets/2e49ba32-8a3b-48c6-8a39-e526bc413dde" />



Now you'll need to create an AppRole with appropriate policies and configure its authentication settings. Here are the steps to create an AppRole:

**a. Create the AppRole**:

```bash
vault write auth/approle/role/terraform \
    secret_id_ttl=30m \
    token_num_uses=10 \
    token_ttl=30m \
    token_max_ttl=40m \
    secret_id_num_uses=40 \
    token_policies=terraform
```
<img width="833" height="174" alt="image" src="https://github.com/user-attachments/assets/61c4b5b7-9b02-4423-b271-1e5b496c27bf" />

- Im not able to find any approle vault snip, able to see only policy snip

3. **Generate Role ID and Secret ID**:

After creating the AppRole, you need to generate a Role ID and Secret ID pair. The Role ID is a static identifier, while the Secret ID is a dynamic credential.

**a. Generate Role ID**:

You can retrieve the Role ID using the Vault CLI:

```bash
vault read auth/approle/role/terraform/role-id
```

Save the Role ID for use in your Terraform configuration.

**b. Generate Secret ID**:

To generate a Secret ID, you can use the following command:

```bash
vault write -f auth/approle/role/my-approle/secret-id
   ```

This command generates a Secret ID and provides it in the response. Save the Secret ID securely, as it will be used for Terraform authentication.
