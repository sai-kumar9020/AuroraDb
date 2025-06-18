package main

deny[msg] {
  input.resource_changes[_].change.after.tags.Owner == ""
  msg = "Owner tag is missing"
}