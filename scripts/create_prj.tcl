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

# Vivadoプロジェクトを作成
set project_name [lindex $argv 0]
create_project $project_name $project_dir -part $part_name

#
# 制約ファイルをインポート
#
set proj_dir [get_property directory [current_project]]
if { [ file exists "$proj_dir/../srcs/constrs/Nexys4DDR.xdc" ] == 1 } then {
    # Create 'constrs_1' fileset (if not found)
    if {[string equal [get_filesets -quiet constrs_1] ""]} {
	create_fileset -constrset constrs_1
    }
    
    # Set 'constrs_1' fileset object
    set obj [get_filesets constrs_1]

    # Add/Import constrs file and set constrs file properties
    set file "[file normalize "$proj_dir/../srcs/constrs/Nexys4DDR.xdc"]"
    set file_added [add_files -norecurse -fileset $obj $file]
    set file "$proj_dir/../srcs/constrs/Nexys4DDR.xdc"
    set file [file normalize $file]
    set file_obj [get_files -of_objects [get_filesets constrs_1] [list "*$file"]]
    set_property -name "file_type" -value "XDC" -objects $file_obj

    # Set 'constrs_1' fileset properties
    set obj [get_filesets constrs_1]
}

