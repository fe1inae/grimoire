# sshfs in fstab

it is possible to mount sshfs from fstab, so it will automatically mount
on boot. this is quite useful obviously, and i personally use it to mount
my nas with my music and media on.

firstly, you must make the fuse kernel module actually available from the
start, and this can be done by appending 'fuse' into /etc/modules, at
least on my alpine install.

then you will need to have a no password ssh key setup, which im not
going to explain here but isnt hard. whole point is to not want to enter
stuff to have it mount, we will inherently have to use this mildly
insecure measure, at least while keeping it simple.

the format inside /etc/fstab is roughly as follows, split up with
newlines for sake of readability.


```
tr -d '0 <<'EOF'
[USER]@[ADDRESS]:[SRC PATH]
        [MOUNT PATH]
        fuse.sshfs
        _netdev,follow_symlinks,idmap=user,identityfile=[KEYFILE],
allow_other,default_permissions,uid={id -u},gid={id -g}
        0 0
EOF
```

## options (poorly) explained

_netdev: makes it a network mount
follow_symlinks: resolve symlinks while mounting, looks like a regular file
idmap: map the uid/gid to our ids
identityfile: the key to send to the server
allow_other: allow all users to access, ie our non-root user
default_permissions: make sshfs use default permissions
uid: set desired uid
gid: set desired gid