<?php



// Not the best name
class userManager
{
    /*
     * @msqli // odbc 
    */
    private $sql;
    /*
     * @public
     * @return {bool}
     *
     */
    public function get():bool
    {
        $route = 'login';
        $message = [];
        if(
            (isset($_POST['login']))&&
            (isset($_POST['password']))
        ){
            $check = $this->sql->queryFunction(
                'password_check',
                [
                    $_POST['login'], 
                    $_POST['password']
                ]
            );
            if($check === NULL){
                 $message[] = 'Access deneid!';
            }else
                 $route = $check.'Page';
        }
        return (new route(
            $route,
            $message
        ))->html();
    }
    function __construct()
    {
        $this->sql = new sql();
    }

}



new userManager();


