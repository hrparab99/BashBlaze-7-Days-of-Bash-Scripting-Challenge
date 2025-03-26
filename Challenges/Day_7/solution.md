# Bash Blaze Day 7 Challenge: Remote Server Management and Web App Deployment

## **Step-by-Step Guide**

### **Phase 1: Setting Up Virtual Machines**

#### **Step 1: Create and Configure VMs**
1. Install **Ubuntu Server 22.04 LTS** or a similar Linux OS on three VMs:
   - `server` (control node)
   - `client1` (web host)
   - `client2` (web host)
2. Connect all three VMs to the **same internal network**.
   - If using VirtualBox:
     - Go to **Settings → Network → Adapter 1 → Internal Network**.
   - Verify connectivity:
     ```bash
     ping <other_VM_IP>
     ```

---

### **Phase 2: Configuring SSH for Secure Communication**

#### **Step 2: Generate SSH Key Pair on Server**
1. On the **server** VM, generate SSH keys:
   ```bash
   ssh-keygen -t rsa -b 4096 -f ~/.ssh/id_rsa -N ""
   ```
2. Copy the SSH key to `client1` and `client2`:
   ```bash
   ssh-copy-id user@client1
   ssh-copy-id user@client2
   ```
   - If `ssh-copy-id` is unavailable, use:
     ```bash
     cat ~/.ssh/id_rsa.pub | ssh user@client1 "mkdir -p ~/.ssh && cat >> ~/.ssh/authorized_keys"
     cat ~/.ssh/id_rsa.pub | ssh user@client2 "mkdir -p ~/.ssh && cat >> ~/.ssh/authorized_keys"
     ```
3. Test passwordless SSH login:
   ```bash
   ssh user@client1
   ssh user@client2
   ```

---

### **Phase 3: Remote Command Execution and Secure File Transfer**

#### **Step 3: Write the `remote_execute.sh` Script**
Create this script on the **server** VM:
```bash
#!/bin/bash

# Define remote clients
clients=("client1" "client2")

# Loop through each client and execute a command
for client in "${clients[@]}"; do
    echo "Checking OS for $client..."
    os_info=$(ssh user@$client "uname -a 2>/dev/null || systeminfo | findstr /B /C:'OS Name' /C:'System Type'")
    echo "$client OS Info: $os_info"
    
    echo "Executing uptime command on $client..."
    ssh user@$client "uname -a && uptime 2>/dev/null || wmic os get LastBootUpTime"
    
    echo "-----------------------------------"
    
done
```
Make it executable and run it:
```bash
chmod +x remote_execute.sh
./remote_execute.sh
```

#### **Step 4: Write the `secure_transfer.sh` Script**
Create this script on the **server** VM:
```bash
#!/bin/bash

# Define remote clients
clients=("client1" "client2")

# Define the file to transfer
file_to_transfer="test_file.txt"

# Ensure the file exists
if [ ! -f "$file_to_transfer" ]; then
    echo "File $file_to_transfer does not exist!"
    exit 1
fi

# Loop through each client and transfer the file
for client in "${clients[@]}"; do
    echo "Transferring $file_to_transfer to $client..."
    scp "$file_to_transfer" user@$client:/home/user/
done
```
Make it executable and run it:
```bash
chmod +x secure_transfer.sh
touch test_file.txt
./secure_transfer.sh
```

---

### **Phase 4: Containerizing a Web Application**

#### **Step 5: Write the `Dockerfile`**
On the **server**, create a directory and a `Dockerfile`:
```bash
mkdir webapp
cd webapp
nano Dockerfile
```
Add the following content:
```dockerfile
FROM nginx:latest
COPY index.html /usr/share/nginx/html/index.html
```
Create a simple `index.html`:
```bash
echo "<h1>Welcome to Bash Blaze WebApp</h1>" > index.html
```

#### **Step 6: Build and Push the Docker Image**
1. **Install Docker** on the **server**:
   ```bash
   sudo apt update
   sudo apt install -y docker.io
   sudo systemctl start docker
   sudo systemctl enable docker
   ```
2. **Build the Docker image**:
   ```bash
   docker build -t bashblaze-webapp .
   ```
3. **Save and transfer the image to clients**:
   ```bash
   docker save bashblaze-webapp | ssh user@client1 "docker load"
   docker save bashblaze-webapp | ssh user@client2 "docker load"
   ```

---

### **Step 7: Deploy the Web Application with Nginx**
Create a `deploy.sh` script on **client1** and **client2**:
```bash
#!/bin/bash

# Run the Docker container
docker run -d -p 80:80 --name webapp bashblaze-webapp
```
Make it executable and run it:
```bash
chmod +x deploy.sh
./deploy.sh
```

Test the deployment by opening:
```bash
curl http://client1
curl http://client2
```

---

### **Phase 5: Final Validation**
1. **Check running containers**:
   ```bash
   docker ps
   ```
2. **Check website availability**:
   ```bash
   curl http://client1
   curl http://client2
   ```
3. **Check Nginx logs**:
   ```bash
   docker logs webapp
   ```

---

### **Final Step: Submit Your Work**
1. Take screenshots of:
   - SSH connection working
   - Remote command execution
   - File transfer
   - Docker container running
   - Web application working
2. Upload your scripts and screenshots to **GitHub**.

---

## **Congratulations! 🎉**
You have successfully implemented **remote server management and web application deployment** using **Bash, SSH, SCP, Docker, and Nginx**.

Would you like additional enhancements, such as **auto-deployment on VM startup** or **monitoring logs in real time**? 🚀

