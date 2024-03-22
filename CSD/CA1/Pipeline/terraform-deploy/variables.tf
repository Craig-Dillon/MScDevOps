###### I know this is a terrible habit
variable "rg" {}

variable "location" {
  type        = string
  description = "Location of Resources"
  default     = "northeurope"
}
