/*=== DATA SOURCES ===*/
data "aws_availability_zones" "available" {}
data "aws_caller_identity" "current" {}

/*=== VARIABLES ===*/
variable "provider" {
    type    = "map"
    default = {
        access_key = "XXXXXG44X6XWTX5HZ55A"
        secret_key = "XXXXX2iH9VGibnKoTU9kEvn6u79U"
        region     = "us-east-1"
    }
}

provider "aws" {
    access_key = "${var.provider["access_key"]}"
    secret_key = "${var.provider["secret_key"]}"
    region     = "${var.provider["region"]}"
}


# Defaults for enc_domain
variable "enc_domain" {
    type    = "map"
    default = {
        name    = "mydomain.com"
    }
}

variable "enc_domain_int" {
	default = "mydomain.internal"
}

variable "vpc" {
    type    = "map"
    default = {
        "id"          = "vpc-test1111"
        "tag"         = "TFTEST"
        "cidr_block"  = "10.99.0.0/20"
        "subnet_bits" = "4"
        "owner_id"    = "930886746757"
        "sns_topic"   = "unknown"
    }
}

variable "azs" {
    type    = "map"
    default = {
        "ap-southeast-2" = "ap-southeast-2a,ap-southeast-2b,ap-southeast-2c"
        "eu-west-1"      = "eu-west-1a,eu-west-1b,eu-west-1c"
        "us-west-1"      = "us-west-1b,us-west-1c"
        "us-west-2"      = "us-west-2a,us-west-2b,us-west-2c"
        "us-east-1"      = "us-east-1a,us-east-1b,us-east-1c,us-east-1d"
    }
}

variable "instance_type" {
    default = "t2.micro"
}

variable "key_name" {
    default = "ec2key"
}

