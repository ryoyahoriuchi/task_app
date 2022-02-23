# README

# User
|  カラム名         | データ型 |
|------------------|---------|
| name             | string  |
| email            | string  |
| password_digest  | string  |

# Task
| カラム名      | データ型  |
|--------------|----------|
| name         | string   |
| explanation  | text     |
| deadline     | integer  |
| progress     | string   |
| priority     | integer  |
| user_id      | index    | 

# Label
| カラム名  | データ型  |
|----------|-----------|
| name     | string    |
| task_id  | index     |