<?php
require_once "conexion.php";
require "vendor/autoload.php";
use \Firebase\JWT\JWT;	



class Metodos 
{
	const secret_key = "ZURI12345";

	public function registroUsuario($nombre,$apellido,$correo,$password,$rol){
		$db = new conexion();
		$pass = md5(trim($password));
		$consulta = "CALL sp_registro_usuario('$nombre','$apellido','$correo','$pass',$rol);";
		$res = $db->query($consulta);
		$row = mysqli_fetch_assoc($res);
		$datos = array();
		$datos['mensaje'] = $row['result_msg'];
		$datos['code'] = $row['result_code'];
		return $datos;
		
	}

	public function login($correo,$password){
		$db = new conexion();
		$pass = md5(trim($password));
		$consulta = "CALL sp_login('$correo','$pass');";
		$res = $db->query($consulta);
		$num = mysqli_affected_rows($db);
		$row = mysqli_fetch_assoc($res);
		$datos = array();
		if($num>0){
			$token=array(
		        "usuario" => $row['nIdUsuario'],
		        "correo" =>$row['sCorreo'],
		        "pass" =>$row['sPassword']
		    );			
			$jwt = JWT::encode($token, self::secret_key);
        	
			$datos['mensaje'] = "Login Exitoso ". $row['sNombre'];
			$datos['token'] = $jwt;
			//$datos['code'] = 1;
		}else{
			$datos['mensaje'] = "no existe";
			$datos['token'] = '';
			//$datos['code'] = 0;
		}
		
		return $datos;
		
	}


}

?>