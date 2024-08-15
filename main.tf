variable "file_name" {

  type = string

  validation {
    condition     = length(var.file_name) >= 5
    error_message = "The filename provided must be 5 characters or more."
  }

}

data "external" "env" {

  program = ["/usr/bin/bash", "-c", "if [ -z \"$${USER_VAR}\" ]; then echo -n '{}'; else echo -n \"{\\\"USER_VAR\\\": \\\"$${USER_VAR}\\\"}\"; fi"]

  lifecycle {
    postcondition {
      condition     = contains(keys(self.result), "USER_VAR")
      error_message = "The variable `USER_VAR` was not set."
    }
  }

}

resource "local_file" "output_file" {

  content  = format("USER_VAR=%s", data.external.env.result["USER_VAR"])
  filename = format("%s/%s", path.root, var.file_name)

}

output "file_path" {

  value = format("%s/%s", path.root, var.file_name)

  precondition {
    condition     = data.external.env.result["USER_VAR"] == "1"
    error_message = "The variable `USER_VAR` was not set to value `1`."
  }

  precondition {
    condition     = can(local_file.output_file.content_sha1)
    error_message = "The output file was not created."
  }

}