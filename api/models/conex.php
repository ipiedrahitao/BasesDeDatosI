<?php
class Connex{
    public static $host = "localhost";
    public static $user = "root";
    public static $pass = "";
    public static $DB = "VETERINARIA";
    public static function conn(){
        
        $conn=mysqli_connect(Connex::$host, Connex::$user, Connex::$pass,Connex::$DB) or die("Error al conectar a la DB " . mysqli_error($link));
        // echo var_dump($conn);

        return $conn;
    } 
}
?>