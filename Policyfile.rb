name 'diiv'

default_source :supermarket

# run_list: chef-client will run these recipes in the order specified.
run_list 'diiv::default'

# Specify a custom source for a single cookbook:
cookbook 'diiv', path: '.'
