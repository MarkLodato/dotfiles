# Python 3 removes reload from the set of builtins.  Add it back.
try:
    from imp import reload
except:
    pass
