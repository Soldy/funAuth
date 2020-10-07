<?php


require_once('sql.security.php');
require_once('sql.connect.php');
require_once('sql.php');
require_once('users.php');
require_once('route.php');


//and call as static anonymous function

if((new userManager())->get()===false)
    (new route());


