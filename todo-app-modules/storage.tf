resource "aws_s3_bucket" "s3_bucket" {
  bucket = "${var.bucket_name}"
}

resource "aws_iam_role" "ec2_instance_roles" {
  name = "ec2_instance_roles_${var.environment}"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
        {
            Action = "sts:AssumeRole",
            Effect = "Allow",
            Principal = {
                Service = "ec2.amazonaws.com"
            }
        }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "s3_read_policy_attachment" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"
  role = aws_iam_role.ec2_instance_roles.name
}

resource "aws_iam_instance_profile" "ec2_roles_instance_profile" {
  name = "iam_ec2_instance_profile_${var.environment}_2"
  role = aws_iam_role.ec2_instance_roles.name
}
