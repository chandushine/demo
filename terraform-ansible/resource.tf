resource "aws_instance" "node1" {
  ami           = "ami-00874d747dde814fa"
  instance_type = "t2.micro"
  key_name      = "mylaptop"
  tags = {
    Name = "ACN"
  }
  provisioner "remote-exec" {
    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = file("~/.ssh/id_rsa")
      host        = aws_instance.node1.public_ip
    }

    inline = [
      "sudo apt update",
      "sudo apt install software-properties-common",
      "sudo add-apt-repository --yes --update ppa:ansible/ansible",
      "sudo apt install ansible -y",
      "ansible --version",
      "git clone https://github.com/chandushine/demo.git",
      "cd demo/terraform-ansible",
      "ansible-playbook -i hosts mongodb.yml"
    ]
  }
}







