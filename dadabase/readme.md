# intigrating ansible with jenkins for install mongodb
-----------------------------------------------------
## **for that we reqiere theese**
## node with jenkins installed ---> this is **master node** of jenkins
  * ensure java installed on it ,becouse jenkins is java made tool so jenkins requrirs java
  * for jenkins installation we have to follow these bellow steps
   ```
   curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io.key | sudo tee \
  /usr/share/keyrings/jenkins-keyring.asc > /dev/null
echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] \
  https://pkg.jenkins.io/debian-stable binary/ | sudo tee \
  /etc/apt/sources.list.d/jenkins.list > /dev/null
sudo apt-get update
sudo apt-get install jenkins -y
   ```

  * we can see the version of jenkins by ` jenkins --version `  
 ### do this automention by using  
## node with ansible installed ---> this in the **ansible controll node** 

  * installations prosess
    - ensure pip installed or not  ` python3 -m pip -V `
    - if pip is not installed follow this steps
      ```
     curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py
     python3 get-pip.py --user
     ```
  **Installing Ansible** 
  * fellow bellow steps
  ```
    python3 -m pip install --user ansible
    python3 -m pip install --user ansible-core==2.12.3
    ansible --version
    python3 -m pip show ansible
  ```
  * 1. in ACN create a user with some passwd
    2. give all sudo permissions to the user in `sudi visudo`
    3. change password authentication no to yes in ` sudo nano /etc/ssh/sshd_config`

  * for configration purpus we have to ganarate ssh keys by using this command `ssh-keygen` in ACN
* next repeate above 1 to 3 steps in onther node where we want to excute our disired state mention in ansible playbook.
* next go to the ACN and copy the genarated ssh key into that node for that use this command `ssh-copy-id username@privateip` of the node.
* for doing this we have to login in to node form the the ansible control node.
* for checking use this command `ansible -i hosts -m ping all`
* we can see like this 
![preview](./images/Capture1.PNG)
* now write a playbook for installing mongodb in ubuntu server
* for this doing we have mention to the ACN 
   - where has to be excuted that is mentioned in ---> inventory file
   - what can be exucuted that is our disired state ,we mentioned in ---> .yml file
 * inventory file look like this (this ini formate file)
  ``` 
172.31.91.66
```
* mogodb.yml file look like this


```yml
---
- name: install mongo db
  become: yes
  hosts: all
  tasks: 
    - name: add apt_key
      ansible.builtin.apt_key:
        url: https://www.mongodb.org/static/pgp/server-5.0.asc
        state: present
    - name: create a list file for your MongoDB package
      ansible.builtin.apt_repository:
        repo: "deb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/ubuntu focal/mongodb-org/5.0 multiverse"
        state: present
        filename: /etc/apt/sources.list.d/mongodb-org-5.0.list
    - name: install mongod
      apt:
        name: mongodb-org
        update_cache: yes
        state: present
    - name: systemd
      ansible.builtin.systemd:
        name: mongod
        enabled: yes
        state: started
  ```
  * *next push the created hosts  and mongodv.yml files to the git hub* 
 ## **configue ansible control node with jenkins**
 * navigate to the browser and give public ip of jenkins master node:8080 `35.174.207.235:8080`
 * navigate to the manage jenkins
![priview](./images/Screenshot%202023-01-31%20152605.png)
* then navigate manage nodes and clouds
![privew](./images/Screenshot%202023-01-31%20152802.png)
* then create a node with the ACN configurations
![preview](./images/Screenshot%202023-01-31%20153050.png)
![priview](./images/Screenshot%202023-01-31%20153205.png)
* now navigate to dashboard and create new item 
![priview](./images/Screenshot%202023-01-31%20153359.png)
![priview](./images/Screenshot%202023-01-31%20153540.png)
* navigate to pipe line and paste the pipeline and save it
![priview](./images/Screenshot%202023-01-31%20153713.png)
![pri]
* now click the build now ![priview](./images/Screenshot%202023-01-31%20153916.png)
* we can see when build was success
![priview](./images/Screenshot%202023-01-31%20155550.png)

#### diclarative pipeline 
* link to mongodb.yml file [priview](mongodb.yml)
 
 ```yml
pipeline {
    agent { label 'ansible' }
    stages {
        stage ('clone') {
            steps {
               git url: "https://github.com/chandushine/demo.git",
               branch: "main"
            }
        }
            stage ('execute play book') {
                steps {
                    sh 'ansible-playbook -i dadabase/hosts dadabase/mongodb.yml'
                }
            }
        }
    }
    ```









       