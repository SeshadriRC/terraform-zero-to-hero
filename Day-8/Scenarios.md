## Scenario - 1: Terraform Import

1. Terraform migration ( using import and then running terraform import command which will create a state file).

- This will import the EC2 instance all details which was created manually.

- Importing EC2 instance to create a state file.

```yaml
provider "aws" {

  region = "ap-south-1"
}

import {
  
  id = "i-0d72d824b11c4ab0a"

  to = aws_instance.example

}

```

```
terraform init
terraform plan -generate-config-out=generated_resources.tf
```

- Now if we give `terraform plan` it will show 1 to add, so address this we need to do terraform import.

<img width="1466" height="357" alt="image" src="https://github.com/user-attachments/assets/a6a30289-7ead-40c5-bbd9-7193645dce51" />

```
terraform import aws_instance.example i-0d72d824b11c4ab0a
```

- statefile generated

<img width="1259" height="147" alt="image" src="https://github.com/user-attachments/assets/4f68e124-43f2-406e-88aa-400f285bee09" />


- We can see no changes required

<img width="1256" height="369" alt="image" src="https://github.com/user-attachments/assets/3d9c281c-f49b-4461-92e3-e8b4d548a3ea" />


---

## Scenario - 2: Terraform drift detection 

- if some one manually changed any settings for any resource, then detecting that change is called drift detection.

- Modified the tags after created

<img width="1600" height="242" alt="image" src="https://github.com/user-attachments/assets/b5225669-0309-4e7b-abcf-32b3a2b2ff40" />

<img width="1298" height="612" alt="image" src="https://github.com/user-attachments/assets/ba0ec079-0299-46c0-a92c-abf78c69ef5c" />


### There are 2 ways to detect it.

Scenario 1: Use terraform refresh using a cron job. ( terraform refresh, refershes the recents changes which was done manually to the statefile and keeps it updated.

Scenario 2: 

- A) Use audit/activity logs to see who made changes, if its changed by user and resources is managed by TF, then send an alert using lambda/azure functions and notify.

<img width="1919" height="740" alt="image" src="https://github.com/user-attachments/assets/cd2df6ed-1627-4f80-b2f7-2974d5c5a145" />


- B) Apply strict IAM rules so that no one can login to console.
