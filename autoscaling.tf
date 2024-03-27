resource "aws_launch_configuration" "my_launch_config" {
  name          = "my-launch-config"
  image_id      = "ami-019f9b3318b7155c5"
  instance_type = "t2.micro"
}

resource "aws_autoscaling_group" "my_auto_scaling_group" {
  name                 = "my-auto-scaling-group"
  launch_configuration = aws_launch_configuration.my_launch_config.name
  min_size             = 1
  max_size             = 3
  desired_capacity     = 2
  vpc_zone_identifier  = [aws_subnet.my_subnet.id]
}
