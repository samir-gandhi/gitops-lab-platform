resource "random_password" "administrativeAccount" {
  length           = 16
  special          = true
  lower            = true
  upper            = true
  numeric          = true
  min_lower        = 2
  min_numeric      = 1
  min_special      = 1
  min_upper        = 1
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

resource "pingfederate_administrative_account" "administrativeAccount" {
  description = "Temp administrative account"

  username      = "temp-admin"
  password      = random_password.administrativeAccount.result
  email_address = format("temp@pingidentity.com")
  active        = true

  roles = ["ADMINISTRATOR", "EXPRESSION_ADMINISTRATOR", "CRYPTO_ADMINISTRATOR"]
}
