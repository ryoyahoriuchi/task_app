# README

# STEP1 assumption_table_schema
```rb
create_table "users", force: :cascade do |t|  
  t.string "name"  
  t.string "email"  
  t.string "password_digest"  
  t.index ["email"], name: "index_users_on_email", unique: true  
end  
  
create_table "tasks", force: :cascade do |t|  
  t.string "name"  
  t.text "explanation"  
  t.integer "deadline"  
  t.string "progress"  
  t.integer "priority"  
  t.index ["user_id"], name: "index_tasks_on_user_id"  
end  
  
create_table "labels", force: :cascade do |t|  
  t.string "name"  
  t.index ["task_id"], name: "index_labels_on_tasks_id"  
end  
  
add_foreign_key "tasks", "users"  
add_foreign_key "labels", "tasks"  

```