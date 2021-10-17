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

	public function creaPublicacion($token, $titulo,$descripcion){
		$db = new conexion();

		$decoded = JWT::decode($token, self::secret_key, array('HS256'));
		$usuario = $decoded->usuario;
		$correo = $decoded->correo;
		$pass = $decoded->pass;

		$datos = array();
		$consulta = "CALL sp_insert_publicacion('$titulo','$descripcion','$correo','$pass');";
		$res = $db->query($consulta);
		$row = mysqli_fetch_assoc($res);			
		$datos['mensaje'] = $row['result_msg'];	
		$datos['idPublicacion'] = $row['result_code'];	
		return $datos;
		
	}

	public function actualizaPublicacion($token, $titulo,$descripcion,$idPublicacion){
		$db = new conexion();

		$decoded = JWT::decode($token, self::secret_key, array('HS256'));
		$usuario = $decoded->usuario;
		$correo = $decoded->correo;
		$pass = $decoded->pass;

		$datos = array();
		$consulta = "CALL sp_actualiza_publicacion('$titulo','$descripcion','$correo','$pass',$idPublicacion);";
		$res = $db->query($consulta);
		$row = mysqli_fetch_assoc($res);			
		$datos['mensaje'] = $row['result_msg'];		
		return $datos;
		
	}

	public function borraPublicacion($token, $idPublicacion){
		$db = new conexion();

		$decoded = JWT::decode($token, self::secret_key, array('HS256'));
		$usuario = $decoded->usuario;
		$correo = $decoded->correo;
		$pass = $decoded->pass;

		$datos = array();
		$consulta = "CALL sp_eliminar_publicacion('$correo','$pass',$idPublicacion);";
		$res = $db->query($consulta);
		$row = mysqli_fetch_assoc($res);			
		$datos['mensaje'] = $row['result_msg'];		
		return $datos;
		
	}

	public function consultaPublicacion($token){
		$db = new conexion();

		$decoded = JWT::decode($token, self::secret_key, array('HS256'));
		$usuario = $decoded->usuario;
		$correo = $decoded->correo;
		$pass = $decoded->pass;

		$datos = array();
		$consulta = "CALL sp_select_publicacion('$correo','$pass');";
		$res = $db->query($consulta);
		$num = mysqli_affected_rows($db);
		
		$datos = array();
		if($num>0){
			while ($row = mysqli_fetch_assoc($res)) {
				$datos[] = [
					'Titulo' =>$row['sTitulo'],
					'Descripcion' =>$row['sDesPublicacion'],
					'Fecha Creacion' =>$row['dFecRegistro'],
					'Nombre' =>$row['nombre'],
					'Id Rol' =>$row['nIdRol'],
					'Rol descripcion' =>$row['sDescripcion']
				];
			}		
		}
				
		return $datos; 
	}


}

?>