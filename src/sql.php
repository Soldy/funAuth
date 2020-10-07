<?php

class sql extends sqlAbstract
{
    use sqlSecurity;
    /*
     * @param {string}
     * @param {array}
     * @public
     * @return {mixed}
     *
     */
    public function queryFunction(string $func, array $varArray ) 
    {
        // I use . because faster 
        $sql = '`'. $func. '`('; 
        $sql.= $this->securitys($varArray);
        $sql.=')';
        return $this->query('SELECT '. $sql)[0][$sql];
    }
    function __construct(){
        $this->connect();
    }
}


