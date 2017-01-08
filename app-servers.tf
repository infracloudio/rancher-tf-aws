/* App servers */
resource "aws_instance" "rancher" {
  count = "${var.k8s_node_count}"
  ami = "${lookup(var.amis, var.region)}"
  instance_type = "${var.aws_machine_type}"
  subnet_id = "${aws_subnet.public.id}"
  vpc_security_group_ids = ["${aws_security_group.web.id}"]
  key_name = "${aws_key_pair.deployer.key_name}"
  source_dest_check = false
  
  tags = { 
    Name = "aws-k8s-node.${count.index}"
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
    "sudo /tmp/install.sh ${count.index} ${aws_instance.rancher.0.public_ip} ${var.rs_proj_name}"
    ]
  }
}
