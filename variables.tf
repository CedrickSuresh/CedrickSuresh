variable "source_instance_id" {
  default     = "i-044417fd519284ffa"
}

variable "resource_tags" {
  description  = "Tags to set for all resource"
  type = map(string)
  default      = {
  Application  = "Sonar"
  Name         = "D1CETSTSQBW06"
  project      = "IT Tooling"
  environment  = "test"
  }
  }
variable "hostname" {
     type = string
     description = "Sets a hostname of the created instance"
     default = "D1CETSTSQBW06"
  }

  variable "user_data" {
    default = true
  }
