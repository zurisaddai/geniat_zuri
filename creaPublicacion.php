<?php
	require_once "metodos.php";

	switch ($_SERVER['REQUEST_METHOD']) {
		case 'POST':
			$metodos = new Metodos();
			$datos = json_decode(file_get_contents('php://input'));
			if($datos!=NULL){
				$respuesta = Metodos::creaPublicacion($datos->token,$datos->titulo,$datos->descripcion);
				echo json_encode($respuesta);
				
			}		
			break;
		
		default:
			# code...
			break;
	}
?>