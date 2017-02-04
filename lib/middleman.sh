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

# Nginx force https
force_https() {
	echo $(nos_validate "$(nos_payload "config_force_https")" "boolean" "false")
}

# Nginx custom error pages
error_pages() {
  declare -a error_pages_list
  if [[ "${PL_config_error_pages_type}" = "array" ]]; then
    for ((i=0; i < PL_config_error_pages_length ; i++)); do
      type=PL_config_error_pages_${i}_type
      if [[ ${!type} = "map" ]]; then
        errors=PL_config_error_pages_${i}_errors_value
        page=PL_config_error_pages_${i}_page_value
        if [[ -n ${!errors} && ${!page} ]]; then
          entry="{\"errors\":\"${!errors}\",\"page\":\"${!page}\"}"
          error_pages_list+=("${entry}")
        fi
      fi
    done
  fi
  if [[ -z "error_pages_list[@]" ]]; then
    echo "[]"
  else
    echo "[ $(nos_join ',' "${error_pages_list[@]}") ]"
  fi
}

# Nginx rewrites
rewrites() {
  declare -a rewrites_list
  if [[ "${PL_config_rewrites_type}" = "array" ]]; then
    for ((i=0; i < PL_config_rewrites_length ; i++)); do
      type=PL_config_rewrites_${i}_type
      if [[ ${!type} = "map" ]]; then
        rewrite_if=PL_config_rewrites_${i}_if_value
        rewrite_then=PL_config_rewrites_${i}_then_value
        if [[ -n ${!rewrite_if} && ${!rewrite_then} ]]; then
          entry="{\"if\":\"${!rewrite_if}\",\"then\":\"${!rewrite_then}\"}"
          rewrites_list+=("${entry}")
        fi
      fi
    done
  fi
  if [[ -z "rewrites_list[@]" ]]; then
    echo "[]"
  else
    echo "[ $(nos_join ',' "${rewrites_list[@]}") ]"
  fi
}

# Generate the payload to render the npm profile template
nginx_conf_payload() {
  cat <<-END
{
  "code_dir": "$(nos_code_dir)",
  "data_dir": "$(nos_data_dir)",
  "force_https": $(force_https),
  "error_pages": $(error_pages),
  "rewrites": $(rewrites)
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
