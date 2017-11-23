admin = db.getSiblingDB("admin")

// Create admin
admin.createUser({
  user: user,
  pwd: pwd,
  roles: [{
    role: "userAdminAnyDatabase",
    db: "admin"
  }]
})

// Authenticate as admin so we can create more users
admin.auth(user, pwd)

// Create an admin user for the replica set
admin.createUser({
  user: "clusterAdmin",
  pwd: pwd,
  roles: [{
    role: "clusterAdmin",
    db: "admin"
  }]
})