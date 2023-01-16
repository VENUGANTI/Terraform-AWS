resource "null_resource" "jenkins" {
  provisioner "local-exec" {
    command = <<EOT
       sleep 180;
       >inv1.ini;
         echo "[jenkins]" | tee -a inv1.ini;     
         echo "${aws_instance.jenkins.public_ip} ansible_user=ubuntu ansible_ssh_private_key_file=./${var.key_name}.pem ansible_python_interpreter=/usr/bin/python3"  | tee -a inv1.ini;
         export ANSIBLE_HOST_KEY_CHECKING=False;
       ansible-playbook -i inv1.ini main.yml -vvv;
      EOT
  }
}

resource "null_resource" "nexus" {
  provisioner "local-exec" {
    command = <<EOT
       sleep 180;
       >inv2.ini;
         echo "[nexus]" | tee -a inv2.ini;     
         echo "${aws_instance.nexus.public_ip} ansible_user=ubuntu ansible_ssh_private_key_file=./${var.key_name}.pem ansible_python_interpreter=/usr/bin/python3"  | tee -a inv2.ini;
      export ANSIBLE_HOST_KEY_CHECKING=False;
       ansible-playbook -i inv2.ini main.yml -vvv;
      EOT
  }
}

resource "null_resource" "tomcat" {
  provisioner "local-exec" {
    command = <<EOT
       sleep 180;
       >inv3.ini;
         echo "[tomcat]" | tee -a inv3.ini;     
         echo "${aws_instance.tomcat_ami_instance.public_ip} ansible_user=ubuntu ansible_ssh_private_key_file=./${var.key_name}.pem ansible_python_interpreter=/usr/bin/python3"  | tee -a inv3.ini;
      export ANSIBLE_HOST_KEY_CHECKING=False;
       ansible-playbook -i inv3.ini main.yml -vvv;
      EOT
  }
}
