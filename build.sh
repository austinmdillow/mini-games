##### build #####

find . -iname "*.lua" -type f | xargs luac -p || { echo 'luac parse test failed' ; exit 1; }
echo 'build passed'
