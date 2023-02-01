module "eks" {
    source  = "terraform-aws-modules/eks/aws"
    cluster_name "Cluster WEB"
    cluster_version = "1.20"
    subnets =   [vpc.main-private-1.subnet]

    tags = {
        Name = "Test"
    }

    vpc_id = vpc.main.id
    workers_group_defaults = {
        root_volume_type = "gp2"
    }



    worker_groups = [
        {
            name    =   "worker-group-1"
            instance_type   =   "t2.small"
            asg_desired_capacity    =   2

        },
        {
            name    =   "worker-group-2"
            instance_type   =   "t2.small"
            asg_desired_capacity    =   1

        }
    ]
}