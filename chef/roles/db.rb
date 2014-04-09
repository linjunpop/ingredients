name "db"
description "Database"

run_list(
  "recipe[mongodb]"
)
