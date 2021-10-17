<?php
	require_once "metodos.php";

	switch ($_SERVER['REQUEST_METHOD']) {
		case 'POST':
			$metodos = new Metodos();
			$datos = json_decode(file_get_contents('php://input'));
			
			if($datos!=NULL){
				try{
					$respuesta = Metodos::creaPublicacion($datos->token,$datos->titulo,$datos->descripcion);
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