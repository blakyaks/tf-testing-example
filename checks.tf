check "user_variables" {

  assert {
    condition     = contains(keys(data.external.env.result), "USER_VAR")
    error_message = "The variable `USER_VAR` was not set."
  }

}

check "output_file" {

  assert {
    condition     = can(local_file.output_file.content_sha1)
    error_message = "Unable to find the file output."
  }

}
