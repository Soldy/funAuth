<?php



abstract class sqlAbstract 
{
    // @object
    private $sql;
    // @var {boolean}
    private $loaded = false;
    // @var {string}
    private $username = "";
    // @var {string}
    private $password = "";
    // @var {string}
    private $host = "";
    // @var {string}
    private $database = "";
    /*
     * @param {string}
     * @protected
     */
    protected function query(string $query) : array
    {
        $rows = [];
        $res = $this->sql->query($query);
        if ($this->sql->errno)
            error_log($this->sql->error, 0);
        if ($res == false)
            return [];
        while ($row = $res->fetch_assoc())
            $rows[] = $row;
        $this->sql->close();
        $this->connect();
        return $rows;
    }
    /*
     * @param {string}
     * @protected
     */
    protected function query(string $query, $arra) : array
    {
        $rows = [];
        $res = $this->sql->query($query);
        if ($this->sql->errno)
            error_log($this->sql->error, 0);
        if ($res == false)
            return [];
        while ($row = $res->fetch_assoc())
            $rows[] = $row;
        $this->sql->close();
        $this->connect();
        return $rows;
    }
    /*
     * @private
     *
     */
    private function config()
    {
        include('../conf.php');
        $this->username = $super_config['sql']['user'];
        $this->password = $super_config['sql']['password'];
        $this->database = $super_config['sql']['db'];
        $this->host = $super_config['sql']['host'];
    }
    /*
     * @protected
     *
     */
    protected function connect()
    {
        if($this->loaded == false)
            $this->config();
        $this->loaded=true;
        $this->sql = new mysqli(
            $this->host, 
            $this->username, 
            $this->password, 
            $this->database
        );
        if ($this->sql->connect_errno)
            die("connection error");
    }
}

