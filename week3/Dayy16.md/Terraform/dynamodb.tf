
resource "aws_dynamodb_table" "pathnex_table" {
  name         = "PathnexTrainingTable"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "ID"

  attribute {
    name = "ID"
    type = "S"
  }

  tags = {
    Name = "Pathnex-DDB"
  }
}
