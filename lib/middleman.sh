# -*- mode: bash; tab-width: 2; -*-
# vim: ts=2 sw=2 ft=bash noet

# source ruby
. ${engine_lib_dir}/ruby.sh

# Copy the code into the live directory which will be used to run the app
publish_release() {
  nos_print_bullet "Moving build into live code directory..."
  if [ -n "$(build_dir)" ]; then
	  rsync -a $(nos_code_dir)/$(build_dir)/ $(nos_app_dir)
	else
		rsync -a $(nos_code_dir)/build/ $(nos_app_dir)
	fi
}

# Extract the build dir from the config.rb if it is listed there
build_dir() {
	cd $(nos_code_dir)
	cat config.rb | grep :build_dir | awk '{ print $3 }' | sed "s/'//g" | sed 's/"//g'
}

# Compile the middleman project
middleman_build() {
	cd $(nos_code_dir)
	nos_run_process "middleman build" "bundle exec middleman build"
}

# Generate the payload to render the npm profile template
nginx_conf_payload() {
  cat <<-END
{
  "code_dir": "$(nos_code_dir)",
  "data_dir": "$(nos_data_dir)"
}
END
}

# Ensure node_modules/.bin is persisted to the PATH
configure_nginx() {
	mkdir -p $(nos_data_dir)/var/tmp/nginx/client_body_temp
  nos_template \
    "nginx/nginx.conf" \
    "$(nos_etc_dir)/nginx/nginx.conf" \
    "$(nginx_conf_payload)"
}