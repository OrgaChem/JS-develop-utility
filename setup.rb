# This script licensed under the MIT.
# http://orgachem.mit-license.org

# This script can works on above directory structure.
#
# {ProjectRoot} / tools / setup.rb (This script)

# Arguments processing module
require 'optparse'

# Absolute path of directory including this script
SCRIPT_DIR_PATH = File.dirname(File.expand_path(__FILE__))
ROOT_DIR_PATH = "#{SCRIPT_DIR_PATH}/../"

# Location of Readme files
GITIGNORE_FILE_PATH = "#{SCRIPT_DIR_PATH}/files/_gitignore"

# Location of Readme symbolic links
GITIGNORE_COPY_PATH = "#{ROOT_DIR_PATH}/.gitignore"

# Location of Readme files
README_FILE_PATH = "#{SCRIPT_DIR_PATH}/files/README.textile"
README_JA_FILE_PATH = "#{SCRIPT_DIR_PATH}/files/README_Ja.textile"

# Location of Readme symbolic links
README_COPY_PATH = "#{ROOT_DIR_PATH}/README.textile"
README_JA_COPY_PATH = "#{ROOT_DIR_PATH}/README_Ja.textile"

repo_name = nil
repo_name_ja = nil
force = false

# Arguments processing
opt = OptionParser.new()
opt.on('-n <NAME>', '--name <NAME>', 'Repository name.') {|v| repo_name = v}
opt.on('-j <NAME_Ja>', '--name_ja <NAME>', 'Repository name in Japanese.') {|v| repo_name_ja = v}
opt.on('-f', '--force', 'Over write if Readme is exists.') {force = true}
argv = opt.parse!(ARGV)

if !repo_name
	raise "Repository name is invalied: #{repo_name}"
end
if !repo_name_ja
	raise "Repository name in Japanese is invalied: #{repo_name_ja}"
end

def create_readme(path, new_path, repo_name, repo_name_ja, force)
	# Repository directory name is escaped " " to "-"
	repo_dir_name = repo_name.gsub(/ /, '-')
	readme_tmp = []
	File.open(path, 'r') do |readme|
		readme.each do |line|
			new_line = line
			new_line = new_line.gsub(/__REPO_NAME__/, repo_name)
			new_line = new_line.gsub(/__REPO_NAME_JA__/, repo_name_ja)
			new_line = new_line.gsub(/__REPO_DIR__/, repo_dir_name)
			readme_tmp.push(new_line)
		end
	end
	if !File.exists?(new_path) or force
		File.open(new_path, 'w+') do |readme|
			readme.puts(readme_tmp.join(""))
		end
	end
end

create_readme(README_FILE_PATH, README_COPY_PATH, repo_name, repo_name_ja, force)
create_readme(README_JA_FILE_PATH, README_JA_COPY_PATH, repo_name, repo_name_ja, force)

if !File.exists?(GITIGNORE_COPY_PATH)
	File.symlink(GITIGNORE_FILE_PATH, GITIGNORE_COPY_PATH)
end
