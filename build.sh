##### build #####

ls ${PATH//:/ }
find . -iname "*.lua" | xargs luac -p || { echo 'luac parse test failed' ; exit 1; }
