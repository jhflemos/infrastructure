stack {
  name        = "prod"
  description = "Stack responsible for the production enviroment infrastrucutre"
  id          = "6d1a8691-fdd5-4cc7-b669-48bf7c30f1c0"
}

globals {
  region      = "eu-west-1"
  environment = "prod"
  route53     = true
}