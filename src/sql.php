<?php

class sql extends sqlAbstract 
{
    use sqlSecurity;
    /* this funcion call the functions on the sql
     *  
     * @param {string}
     * @param {array} variables
     * @public
     * @return {mixed} always come back with the first line. 
     * 
     *
     */
    public function queryFunction(string $func, array $vari_array ) 
    {
        // I use . because it's faster
        $sql = '`'. $func. '`('; 
        $sql.= $this->securitys($var_array); 
        $sql.=')';
        // And its not a prepare syntax jet... because that not a live code
        // That should brake the solid o.
        return $this->query(
           'SELECT '. $sql // Not
        )[0][$sql]; 
    }
    function __construct(){
        $this->connect();
    }
}


