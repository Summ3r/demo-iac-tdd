output "elb_dns_name" {
  value = aws_elb.example.dns_name
}












//output "instance_public_ips" {
//  value = aws_elb.example.*.instances
//}

//output "instance_public_ips" {
//  value = [aws_instance.web.*.public_ip]
//}