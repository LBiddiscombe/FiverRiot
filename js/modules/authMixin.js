var loggedInUser = ''

var authMixin = {
  setUser: function(user) {
    loggedInUser = user
  },
  isLoggedIn: function() {
    return loggedInUser != ''
  },
  isAdmin: function() {
    // TODO, get admins from club settings
    return (
      loggedInUser === 'lee.biddiscombe@btinternet.com' ||
      'jonathan.bishop@btinternet.com'
    )
  }
}

export { authMixin }
