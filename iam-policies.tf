resource "aws_iam_role" "rancher-k8s-node-role" {
  name               = "rancher-k8s-node-role"
  path               = "/system/"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_role" "rancher-k8s-master-role" {
  name               = "rancher-k8s-master-role"
  path               = "/system/"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_policy" "rancher-k8s-master-policy" {
  name = "rancher-k8s-master-role-policy"
  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "ec2:*"
            ],
            "Resource": [
                "*"
            ]
        },
        {
            "Effect": "Allow",
            "Action": [
                "elasticloadbalancing:*"
            ],
            "Resource": [
                "*"
            ]
        },
        {
            "Effect": "Allow",
            "Action": "s3:*",
            "Resource": [
                "arn:aws:s3:::kubernetes-*"
            ]
        }
    ]
}
EOF
}

resource "aws_iam_policy" "rancher-k8s-node-policy" {
  name = "rancher-k8s-node-policy"
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "s3:*",
      "Resource": [
        "arn:aws:s3:::kubernetes-*"
      ]
    },
    {
      "Effect": "Allow",
      "Action": "ec2:Describe*",
      "Resource": "*"
    },
    {
      "Effect": "Allow",
      "Action": "ec2:AttachVolume",
      "Resource": "*"
    },
    {
      "Effect": "Allow",
      "Action": "ec2:DetachVolume",
      "Resource": "*"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "rancher-k8s-master-attach" {
    role       = "${aws_iam_role.rancher-k8s-master-role.name}"
    policy_arn = "${aws_iam_policy.rancher-k8s-master-policy.arn}"
}

resource "aws_iam_role_policy_attachment" "rancher-k8s-node-attach" {
    role       = "${aws_iam_role.rancher-k8s-node-role.name}"
    policy_arn = "${aws_iam_policy.rancher-k8s-node-policy.arn}"
}