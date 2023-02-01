#Create EKS IAM Role Access
resource "aws_iam_role" "web_EKS" {
    name = "eks-permission-web"

    assume_role_policy = <<POLICY

    {
        "Version" "2012-10-17"
        "Statement": [
            {
                "Effect" = "Allow"
                "Principal": {
                    "service": "eks.amazonaws.com"
                },
                "Action": "sts:AssumeRole"
            }
        ]
    }
    POLICY
}

#Attach policy to above role
resource "aws_iam_role_policy_attachment" "webapp-EKS-policy" {
    policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
    role    = aws_iam_role.web_EKS.name
}

#Create the EKS Cluster

resource "aws_eks_cluster" "cluster" {
    name = "Web EKS Cluster"
    role_arn    =   aws_iam_role.web_EKS.arn

    vpc_config {
        subnet_ids = [
            aws_subnet.main-public-1.id,
            aws_subnet.main-public-2.id,
            aws_subnet.main-private-1.id,
            aws_subnet.main-private-2.id
        ]
    }

    depends_on = [aws_iam_role_policy_attachment.webapp-EKS-policy]
}