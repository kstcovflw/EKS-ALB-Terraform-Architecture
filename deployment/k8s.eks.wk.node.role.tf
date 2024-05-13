resource "aws_eks_node_group" "eks_node_role" {
  cluster_name    = module.eks.cluster_name
  node_group_name = "eks-node-role"
  node_role_arn   = aws_iam_role.eks_node_role.arn

  subnet_ids     = module.vpc.private_subnets
  instance_types = ["t3.medium"] # Adjust to your desired instance type

  scaling_config {
    desired_size = 1
    max_size     = 2
    min_size     = 1
  }

  update_config {
    max_unavailable = 1
  }

  remote_access {
    ec2_ssh_key = "eks-node-role-key"
    source_security_group_ids = [
      aws_security_group.eks_nodes_sg.id
    ]
  }

  depends_on = [
    aws_iam_role_policy_attachment.eks_node_role-AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.eks_node_role-AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.eks_node_role-AmazonEC2ContainerRegistryReadOnly,
  ]
}

resource "aws_iam_role" "eks_node_role" {
  name = "eks-node-group-eks_node_role"

  assume_role_policy = jsonencode({
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    }]
    Version = "2012-10-17"
  })
}

resource "aws_iam_role_policy_attachment" "eks_node_role-AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.eks_node_role.name
}

resource "aws_iam_role_policy_attachment" "eks_node_role-AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.eks_node_role.name
}

resource "aws_iam_role_policy_attachment" "eks_node_role-AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.eks_node_role.name
}

# List and Describe

resource "aws_iam_policy" "eks_describe_list_policy" {
  name        = "eks-describe-list-policy"
  description = "Allows listing and describing EKS resources"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "eks:Describe*",
          "eks:List*"
        ],
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "eks_describe_list_attachment" {
  role       = aws_iam_role.eks_node_role.name
  policy_arn = aws_iam_policy.eks_describe_list_policy.arn
}
