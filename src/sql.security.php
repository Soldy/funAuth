<?php

// because every body need a triats.

trait sqlSecurity {
   /* 
   * @param {string} input text 
   * @rotected
   * @return {string} safe string 
   */
    protected function security(string $string) : string
    {
        return htmlspecialchars($string, ENT_QUOTES);
    }
   /* 
   * @param {array} input 
   * @rotected
   * @return {string} safe string 
   */
    protected function securitys(array $varArray) : string
    {
        $out = "";
        for($i=0;count($varArray)>$i;$i++){
            if($i>0) $out.=", ";
            $out.="'".$this->security($varArray[$i])."'";
        }
        return $out;
    }
}

