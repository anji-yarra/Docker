resource "aws_instance" "Docker-EC2" {
    ami                     = data.aws_ami.joindevops.id
    instance_type           = "t3.micro"
    vpc_security_group_ids  = [aws_security_group.allow_docker.id]

    user_data               = templatefile("${path.module}/docker.sh.tftpl",
    {
        partition_number      = 4
        extend_size         = 30

    })

    root_block_device {
        volume_size         = 50
        volume_type         = "gp3"
    }

    tags = {
        Name         = "Docker"
        Project     = "Roboshop"
        Environment = "Dev"
    } 
}

resource "aws_security_group" "allow_docker" {
    name                   = "allow_terraform"
    description            = "Allow TLS inbound traffic and all outbound traffic"

    ingress {
        from_port          = 22
        to_port            = 22
        protocol           = "tcp"
        cidr_blocks        = ["${chomp(data.http.my_public_ip.response_body)}/32"]
    }

    ingress {
        from_port          = 80
        to_port            = 80
        protocol           = "tcp"
        cidr_blocks        = ["0.0.0.0/0"]
    }

    ingress {
        from_port          = 8080
        to_port            = 8080
        protocol           = "tcp"
        cidr_blocks        = ["0.0.0.0/0"]
    }

    ingress {
        from_port          = 8081
        to_port            = 8081
        protocol           = "tcp"
        cidr_blocks        = ["0.0.0.0/0"]
    }


    egress {
        from_port          = 0
        to_port            = 0
        protocol           = "-1"
        cidr_blocks        = ["0.0.0.0/0"]
    }

    tags = {
        Name        = "allow_docker"
        Project     = "Roboshop"
        Environment = "Dev"
    }

}