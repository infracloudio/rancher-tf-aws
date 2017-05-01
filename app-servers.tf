/* Instance Profiles */

resource "aws_iam_instance_profile" "rancher_k8s_node_profile" {
  name  = "rancher_k8s_node_profile"
  role = "${aws_iam_role.rancher-k8s-node-role.name}"
}

resource "aws_iam_instance_profile" "rancher_k8s_master_profile" {
  name  = "rancher_k8s_master_profile"
  role = "${aws_iam_role.rancher-k8s-master-role.name}"
}

resource "aws_instance" "rancher-master" {
  ami = "${lookup(var.amis, var.region)}"
  instance_type = "${var.aws_machine_type}"
  subnet_id = "${aws_subnet.public.id}"
  vpc_security_group_ids = ["${aws_security_group.web.id}"]
  key_name = "${aws_key_pair.deployer.key_name}"
  source_dest_check = false
  iam_instance_profile = "${aws_iam_instance_profile.rancher_k8s_master_profile.name}"

  tags = {
    Name = "aws-k8s-master"
    Type = "rancher-k8s-master"
  }
  connection {
    type = "ssh"
    user = "ubuntu"
    private_key = "${file("ssh/${aws_key_pair.deployer.key_name}")}"
    timeout = "2m"
    agent = false
	}
  provisioner "file" {
    source = "scripts/install.sh"
    destination = "/tmp/install.sh"
  }

  provisioner "remote-exec" {
    inline = [
    "chmod +x /tmp/install.sh",
    "sudo /tmp/install.sh 0 ${aws_instance.rancher-master.public_ip} ${var.rs_proj_name}"
    ]
  }
}

/* k8s - nodes */
resource "aws_instance" "rancher-node" {
  count = "${var.k8s_node_count}"
  ami = "${lookup(var.amis, var.region)}"
  instance_type = "${var.aws_machine_type}"
  subnet_id = "${aws_subnet.public.id}"
  vpc_security_group_ids = ["${aws_security_group.web.id}"]
  key_name = "${aws_key_pair.deployer.key_name}"
  source_dest_check = false
  iam_instance_profile = "${aws_iam_instance_profile.rancher_k8s_node_profile.name}"
  
  tags = { 
    Name = "aws-k8s-node.${count.index + 1}"
    Type = "rancher-k8s-node"
  }
  connection {
    type = "ssh"
    user = "ubuntu"
    private_key = "${file("ssh/${aws_key_pair.deployer.key_name}")}"
    timeout = "2m"
    agent = false
	}  
  provisioner "file" {
    source = "scripts/install.sh"
    destination = "/tmp/install.sh"
  }
  
  provisioner "remote-exec" {
    inline = [
    "chmod +x /tmp/install.sh",
    "sudo /tmp/install.sh ${count.index + 1} ${aws_instance.rancher-master.public_ip} ${var.rs_proj_name}"
    ]
  }
}
