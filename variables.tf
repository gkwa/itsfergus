variable "auth_type" {
 description = "Authentication type (iam or key)"
 type        = string
 default     = "iam"
 
 validation {
   condition     = contains(["iam", "key"], var.auth_type)
   error_message = "auth_type must be either 'iam' or 'key'"
 }
}
