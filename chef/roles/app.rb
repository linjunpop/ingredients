name "app"
description "App role"

run_list(
  "recipe[chruby::system]",
  "recipe[nodejs::install_from_package]"
)
override_attributes(
  chruby: {
    rubies: {
      "1.9.3-p392" => false,
      "2.1.1" => true
    },
    default: "2.1.1",
    auto_switch: true
  }
)
