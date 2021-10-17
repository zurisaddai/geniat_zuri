<?php
	require_once "metodos.php";

	switch ($_SERVER['REQUEST_METHOD']) {
		case 'GET':
			$metodos = new Metodos();
			$datos = json_decode(file_get_contents('php://input'));
			
			if($datos!=NULL){
				try{
					$respuesta = Metodos::consultaPublicacion($datos->token);
					echo json_encode($respuesta);
				}
				catch (Exception $e){

    			http_response_code(401);
			    echo json_encode(array(
			        "message" => "Acceso denegado.",
			        "error" => $e->getMessage()
			    ));
				
				}
			}	
			break;
		
		default:
			# code...
			break;
	}
?>