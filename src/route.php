<?php


// simple route class was the original plan buit that a view manager. 


class route
{
     // defenet overthink ;)
     // @var {string}
     public $route = 'login';
     // @var {array}
     public $messages = [];
     /* html example output
      * @public 
      * @return {bool}
     */
     public function html():bool
     {

         //that just an example. I did this because I not have any template engine jet.
         $messages = $this->messages;
         include_once('../views/elements/head.php');
         include_once('../views/elements/message.php');
         include_once('../views/'.$this->route.'.php');
         include_once('../views/elements/bottom.php');
         return true;
     }
     /* json example output for apis 
      * @public 
      * @return {bool}
     */
     public function json()
     {

     }
     function __construct (string $route = 'login', array $messages = [])
     {
         $this->route    = $route;
         $this->messages = $messages;
     }
}


