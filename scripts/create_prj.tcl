# FPGAのチップ名を設定
if { $argc < 3 } {
    set part_name "xc7a100tcsg324-1"
} else {
    set part_name [lindex $argv 2]
}

# プロジェクトの作成ディレクトリを指定
if { $argc < 2} {
    set project_dir "."
} else {
    set project_dir [lindex $argv 1]
}

if { $argc == 0 } {
    puts "Error: No Vivado project name.\n"
    puts "Usage:\n"
    puts "    vivado -mode batch -source create_prj.tcl -tclargs <project_name> [<project_dir>] [<part_name>]\n\n"
    puts "Default <project_dir> is current directory, and <part_name> is xc7a100tcsg324-1\n"
    exit 1
}

set project_name [lindex $argv 0]

create_project $project_name $project_dir -part $part_name
