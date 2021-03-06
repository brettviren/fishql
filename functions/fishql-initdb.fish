function fishql-initdb -d "Initialize fishql database"

    if test -z "$fishql_db"
        echo "fishql: please set fishql_db to a DB name"
        return
    end

    set -g fishql_dbfile $__fish_user_data_dir/fishql-"$fishql_db".db

    if test -s $fishql_dbfile
        # fixme: quiet this when done debugging
        # echo "Existing fish history query langauge DB $fishql_db file:"
        # echo $fishql_dbfile
        fishql-session
        return
    end

    # echo "Initialize fish history query language DB $fishql_db file:"
    # echo $fishql_dbfile

    echo "
    CREATE TABLE sessions ( 
      id integer primary key autoincrement, 
      hostname varchar(128), 
      host_ip varchar(40), 
      ppid int(5) not null, 
      pid int(5) not null, 
      time_zone str(3) not null, 
      start_time integer not null, 
      end_time integer, 
      duration integer, 
      tty varchar(20) not null, 
      uid int(16) not null, 
      euid int(16) not null, 
      logname varchar(48), 
      shell varchar(50) not null, 
      sudo_user varchar(48), 
      sudo_uid int(16), 
      ssh_client varchar(60), 
      ssh_connection varchar(100) 
    );
    CREATE TABLE commands (
      id integer primary key autoincrement,
      session_id integer not null,
      shell_level integer not null,
      command_no integer,
      tty varchar(20) not null,
      euid int(16) not null,
      cwd varchar(256) not null,
      rval int(5) not null,
      start_time integer not null,
      end_time integer not null,
      duration integer not null,
      pipe_cnt int(3),
      pipe_vals varchar(80),
      command varchar(1000) not null,
      UNIQUE(session_id, command_no)
    );
    " | fishql-query
    chmod 600 $fishql_dbfile
    fishql-session
end
