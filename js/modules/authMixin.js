var loggedInUser = ''

var authMixin = {
  setUser: function(user) {
    loggedInUser = user
  },
  isAdmin: function() {
    // TODO, get admins from club settings
    return loggedInUser === 'lee.biddiscombe@btinternet.com'
  }
}

export { authMixin }
