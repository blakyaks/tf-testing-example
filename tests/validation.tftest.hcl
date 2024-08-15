run "validate_file_name_length_failure" {

  variables {
    file_name = "fail" # < 5 characters
  }

  command         = plan
  expect_failures = [var.file_name]

}

run "validate_file_name_length_success" {

  variables {
    file_name = "success" # >=5 characters
  }

  command         = plan
  expect_failures = [check.output_file]

}