<?php
	require_once "metodos.php";

	switch ($_SERVER['REQUEST_METHOD']) {
		case 'POST':
			$metodos = new Metodos();
			$datos = json_decode(file_get_contents('php://input'));
			if($datos!=NULL){
				$respuesta = Metodos::registroUsuario($datos->nombre,$datos->apellido,$datos->correo,$datos->password,$datos->rol);
				echo json_encode($respuesta);
				
			}		
			break;
		
		default:
			# code...
			break;
	}
?>