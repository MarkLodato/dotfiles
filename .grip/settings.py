import netrc
try:
    USERNAME, _, PASSWORD = netrc.netrc().hosts['api.github.com']
except KeyError:
    pass
HOST = 'localhost'
PORT = 8000
