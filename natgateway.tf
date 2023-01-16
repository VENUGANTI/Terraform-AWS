resource "aws_eip" "eip_nat_gateway" {
  vpc = true

  tags = {
    Name = "EIP"
  }
}


resource "aws_nat_gateway" "natgw" {
  allocation_id = aws_eip.eip_nat_gateway.id
  subnet_id     = aws_subnet.public_subnet_1.id

  tags = {
    Name = "gat_gw"
  }
  depends_on = [aws_internet_gateway.igw]
}
