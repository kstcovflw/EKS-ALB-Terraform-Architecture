module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "20.10.0"

  cluster_name = "${var.stage}-${var.name}-eks-cluster"

  cluster_endpoint_public_access           = true
  cluster_endpoint_private_access          = true
  enable_cluster_creator_admin_permissions = true

  vpc_id                   = module.vpc.vpc_id
  subnet_ids               = module.vpc.private_subnets
  control_plane_subnet_ids = module.vpc.intra_subnets

  # Automatically manage aws-auth ConfigMap
  authentication_mode = "API_AND_CONFIG_MAP"

  enable_irsa = true

  eks_managed_node_group_defaults = {
    ami_type = "AL2_x86_64"
  }

  # Adding cluster addons with the most recent versions
  cluster_addons = {
    # Ensures reliable name resolution for all services and pods.
    coredns = {
      most_recent = true
    }
    kube-proxy = {
      most_recent = true
    }
    # Manages IP allocation for pods and integrates them into your VPC network
    vpc-cni = {
      most_recent = true
    }
  }

  eks_managed_node_groups = {
    general = {
      name            = "general-eks-mng"
      use_name_prefix = true

      disk_size = 30

      min_size     = 1
      max_size     = 3
      desired_size = 2

      labels = {
        role = "general"
      }

      instance_type = ["t3.small"]

      spot = {
        desired_size = 1
        min_size     = 1
        max_size     = 3
      }
    }
  }
}
