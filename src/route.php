<?php


// simple route class 


class route
{
     // defenet overthink ;)
     // @var {string}
     public $route = 'login';
     // @var {array}
     public $messages = [];
     /*
      * @public 
      * @return {bool}
     */
     public function html():bool
     {
         $messages = $this->messages;
         include_once('../views/elements/head.php');
         include_once('../views/elements/message.php');
         include_once('../views/'.$this->route.'.php');
         include_once('../views/elements/bottom.php');
         return true;
     }
     function json()
     {

     }
     function __construct (string $route = 'login', array $messages = [])
     {
         $this->route    = $route;
         $this->messages = $messages;
     }
}


