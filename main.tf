module "vpc-a" {
  source = "./vpc"

  name = "mhko-terraform-vpc1"
  cidr = "10.10.0.0/16"
  create_igw = true
  create_natgw = true

  public_subnets = {
    sub-1 = {
      az   = "us-east-2c"
      cidr = "10.10.10.0/24"
    }
  }
  private_subnets = {
    sub-1 = {
      az   = "us-east-2c"
      cidr = "10.10.20.0/24"
    }
  }
}

module "vpc-b" {
  source = "./vpc"

  name = "mhko-terraform-vpc2"
  cidr = "10.20.0.0/16"
  create_igw = false
  create_natgw = false

  private_subnets = {
    sub-1 = {
      az   = "ap-northeast-2"
      cidr = "10.20.10.0/24"
    }
  }
}

module "ec2_instance-a" {
  source     = "./ec2"
  depends_on = [module.vpc-a]

  vpc_id    = module.vpc-a.vpc_id
  subnet_id = module.vpc-a.private_subnet_ids["sub-1"]

  name          = "terraform_private_demo_a"
  instance_type = "t2.micro"
  ami           = "ami-0eea504f45ef7a8f7"
  instance_public_ip = false
}

module "ec2_instance-b" {
  source     = "./ec2"
  depends_on = [module.vpc-b]

  vpc_id    = module.vpc-b.vpc_id
  subnet_id = module.vpc-b.private_subnet_ids["sub-1"]

  name          = "terraform_private_demo_b"
  instance_type = "t2.micro"
  ami           = "ami-0eea504f45ef7a8f7"
  instance_public_ip = false
}