output "vpc_id" {
    description = "vpc's id"
    value = aws_vpc.main.id
}

output "public_subnet_ids" {
    description = "public subnet id's"
    value = [aws_subnet.public_subnet1.id, aws_subnet.public_subnet2.id]
}

output "private_subnet_ids" {
    description = "private subnet id's"
    value = [aws_subnet.private_subnet1.id, aws_subnet.private_subnet2.id]
}