<?php

// because every body need a triats.

trait sqlSecurity {
   /*  I am a little bit paranoid I always double check every thing.
   * @param {string} input text 
   * @rotected
   * @return {string} safe string 
   */
    protected function security(string $string) : string
    {
        return htmlspecialchars($string, ENT_QUOTES); // not a real full safe filter just an example
    }
   /* the functions may have multiple inputs
   * @param {array} input 
   * @rotected
   * @return {string} safe string  // the output is a ready to push string.
   */
    protected function securitys(array $var_array) : string // the prepare syntax should replace this function to
    {
        $out = "";
        for($i=0;count($var_array)>$i;$i++){
            if($i>0) $out.=", ";
            $out.="'".$this->security($var_array[$i])."'";
        }
        return $out;
    }
}

