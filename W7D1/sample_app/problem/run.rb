# User.all # shows no users
# empty_gage = User.new
# empty_gage.save # rollback because of failed validations
# password_too_short_gage = User.new(username: 'gage', password: 'test')
# password_too_short_gage.save # rollback because of failed validations
# gage = User.new(username: 'gage', password: 'testing')
# gage.save # inserted into Users
# User.all #<ActiveRecord::Relation [#<User id: 1, username: "gage"...
# User.first.password_digest # shows a string of gibberish that you can't hack