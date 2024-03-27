
resource "aws_internet_gateway" "my_internet_gateway" {
  vpc_id = aws_vpc.my_vpc.id
}

resource "aws_route" "internet_gateway_route" {
  route_table_id         = aws_vpc.my_vpc.main_route_table_id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.my_internet_gateway.id
}



resource "aws_lb" "my_alb" {
  name               = "my-application-load-balancer"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.my_security_group.id]
  subnets            = [aws_subnet.my_subnet_a.id, aws_subnet.my_subnet_b.id]
}

resource "aws_lb_target_group" "my_target_group" {
  name        = "my-target-group"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = aws_vpc.my_vpc.id
  target_type = "instance"
}


resource "aws_instance" "my1_instance" {
  ami           = "ami-019f9b3318b7155c5"
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.my_subnet.id
  associate_public_ip_address = true
  security_groups    = [aws_security_group.my_security_group.id]
  user_data     = <<-EOF
    #!/bin/bash
    #Use this for your user data(script from top to bottom)
    #install httpd (linux 2 version)
    yum update -y
    yum install -y httpd
    systemctl start httpd
    systemctl enamble httpd
    echo "<h1>Hello World from $(hostname -f)<h1>" | sudo tee /var/www/html/index.html
EOF
  tags = {
    Name = "my1-instance"
  }
}

resource "aws_instance" "my2_instance" {
  ami           = "ami-019f9b3318b7155c5"
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.my_subnet.id
  associate_public_ip_address = true
  security_groups    = [aws_security_group.my_security_group.id]
  user_data     = <<-EOF
    #!/bin/bash
    #Use this for your user data(script from top to bottom)
    #install httpd (linux 2 version)
    yum update -y
    yum install -y httpd
    systemctl start httpd
    systemctl enamble httpd
    echo "<h1>Hello World from $(hostname -f)<h1>" | sudo tee /var/www/html/index.html
EOF
  tags = {
    Name = "my2-instance"
  }
}

resource "aws_lb_target_group_attachment" "my1_attachment" {
  target_group_arn = aws_lb_target_group.my_target_group.arn
  target_id        = aws_instance.my1_instance.id
  port             = 80
}

resource "aws_lb_target_group_attachment" "my2_attachment" {
  target_group_arn = aws_lb_target_group.my_target_group.arn
  target_id        = aws_instance.my2_instance.id
  port             = 80
}


resource "aws_lb_listener" "my_listener" {
  load_balancer_arn = aws_lb.my_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.my_target_group.arn
  }
}
