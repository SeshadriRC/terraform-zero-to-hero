Here’s a **short & practical explanation** of Terraform Workspaces 👇

---

# 🧠 What is Terraform Workspace?

A **Terraform workspace** lets you manage **multiple environments (dev, test, prod)** using the **same code**, but with **separate state files**.

👉 Instead of duplicating code, you just switch workspace.

---

# 📌 Example

Same `main.tf`, different environments:

* `dev` → small EC2
* `prod` → bigger EC2

Each workspace has its own:

* state file
* resources

---

# 🔥 Why use it?

✔ Avoid duplicate Terraform code
✔ Isolate environments
✔ Easy switching
✔ Useful for DevOps workflows

---

# ⚙️ Important Commands

### 1. List workspaces

```bash
terraform workspace list
```

---

### 2. Create new workspace

```bash
terraform workspace new dev
```

---

### 3. Switch workspace

```bash
terraform workspace select dev
```

---

### 4. Show current workspace

```bash
terraform workspace show
```

---

### 5. Delete workspace

```bash
terraform workspace delete dev
```

⚠️ Cannot delete currently active workspace

---

# 🧩 How to use in code

Use workspace name inside Terraform:

```hcl
resource "aws_instance" "example" {
  instance_type = terraform.workspace == "prod" ? "t2.medium" : "t2.micro"
}
```

👉 So:

* dev → t2.micro
* prod → t2.medium

---

# ⚠️ Important Notes

❗ Default workspace = `default`
❗ Each workspace has separate **terraform.tfstate**
❗ Works best with **remote backends (S3)**

---

# 🚀 Real DevOps Usage

* `dev`, `qa`, `prod`
* Feature-based environments
* Safe testing without affecting production

---
