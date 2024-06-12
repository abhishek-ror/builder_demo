module LoginHelpers
    def login_user(user)
        BuilderJsonWebToken.encode(user.id, 1.year.from_now, token_type: 'login')
    end
end