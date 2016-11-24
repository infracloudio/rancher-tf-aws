output "nat.ip" {
  value = "${aws_instance.nat.public_ip}"
}
output "rancher.0.ip" {
  value = "${aws_instance.rancher.0.public_ip}"
}