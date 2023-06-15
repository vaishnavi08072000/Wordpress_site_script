# Wordpress_site_script
Creating wordpress site using Bash Script.

# make the script executable using below command
chmod +x <Script_file_name.sh>

# Run the command to execute the script.
./<Script_file_name.sh> example.com

# Please open http://example.com in your browser to access the site.

# another subcommand to enable the site (starting the containers)
./<Script_file_name.sh> enable

# another subcommand to disable the site (stopping the containers)
./<Script_file_name.sh> disable

# subcommand to delete the site (deleting containers and local files).
./<Script_file_name.sh> delete
