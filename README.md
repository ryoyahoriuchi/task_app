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

# デプロイの手順
1. $ heroku login
1. $ heroku create
1. ※Ruby2.6.5を使用している場合
    1. 「Gemfile」のruby '2.6.5'をコメントアウトする
    1. $ bundle install
1. $ git add -A
1. $ git commit -m "init"
1. $ heroku buildpacks:set heroku/ruby
1. $ heroku buildpacks:add --index 1 heroku/nodejs
1. $ git push heroku master