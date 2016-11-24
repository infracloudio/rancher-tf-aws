resource "aws_key_pair" "deployer" {
  key_name = "${var.aws_private_key_name}"
  //public_key = "${file(\"ssh/id_rsa.pub\")}"
  public_key = "${var.aws_public_key}"
}