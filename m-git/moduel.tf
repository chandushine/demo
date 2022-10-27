module "chandu" {
    source = "D:/terraform/hello_world/modules/md-vpc"
    region = "us-east-1"
    cide_subnet = ["10.10.0.0/24","10.10.1.0/24","10.10.2.0/24"]
    cidr_vpc = "10.10.0.0/16"
    sub_name = [ "sub1","sub2","sub3" ]
  
}