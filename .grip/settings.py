import netrc
USERNAME, _, PASSWORD = netrc.netrc().hosts['api.github.com']
HOST = '0.0.0.0'
PORT = 8000
