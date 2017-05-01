output "rancher.0.ip" {
  value = "${aws_instance.rancher-master.public_ip}"
}