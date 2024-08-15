# Variables defined at global level will be used by all `run` blocks, unless overridden
variables {
  file_name = "test.txt"
}

run "plan" {

  # We can override any global variables here
  variables {
    file_name = "my_test.txt"
  }

  # We must define that this is a plan only; the default action is to plan and apply
  command = plan

  # The `output_file` check will produce a warning during plan, we need to exclude this
  expect_failures = [check.output_file]

}

run "apply" {

  # Use the global variables for an apply (no variables block or `command` directive)

  # Assert blocks perform checks against the state AFTER the apply has completed
  assert {
    condition     = length(local_file.output_file.content_sha1) > 0
    error_message = "The file output resource did not report a SHA1 hash."
  }

  assert {
    condition     = local_file.output_file.content == "USER_VAR=1"
    error_message = "The output file did not contain the expected content."
  }

}

run "outputs" {

  # We define the test source as an empty directory
  # This prevents another apply being completed and detaches the test from the current state
  module {
    source = "./tests"
  }

  # Here we are simply checking outputs from the apply run
  assert {
    condition     = endswith(run.apply.file_path, "test.txt")
    error_message = "The `file_path` output was not set correctly."
  }

}