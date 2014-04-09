name "base"
description "A server of some kind..."

default_attributes(
  authorization: {
    sudo: {
      "groups" => ["sysadmin"],
      "users" => ["deploy"],
      "passwordless" => "true"
    }
  }
)
run_list(
  "recipe[openssl]",
  "recipe[build-essential]",
  "recipe[chef-solo-search]",
  "recipe[users::sysadmins]",
  "recipe[sudo]",
  "recipe[git]",
  "recipe[vim]"
)
