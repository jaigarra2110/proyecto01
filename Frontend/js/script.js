
//Método para el cambio de pestañas en la página de inicio
const btnSignIn=document.getElementById("sign-in"),
      btnSignUp=document.getElementById("sign-up");
      formRegister=document.querySelector(".register");
      formLogin=document.querySelector(".login");


btnSignIn.addEventListener("click", e=>{
    formRegister.classList.add("hide");
    formLogin.classList.remove("hide");
})

btnSignUp.addEventListener("click", e=>{
    formLogin.classList.add("hide");
    formRegister.classList.remove("hide");
})
//Fin del método.


//Para ver los roles en una lista: 
document.addEventListener("DOMContentLoaded", async function() {
    const rolSelect = document.getElementById("idRol");

    try {
        // Realizar una solicitud GET para obtener los roles
        const response = await fetch("https://localhost:7046/api/Rol/ver/rol");
        const roles = await response.json();

        // Llenar el select con los roles obtenidos
        roles.forEach(rol => {
            const option = document.createElement("option");
            option.value = rol.idRol;  // El valor será el IdRol
            option.text = rol.nombreRol; // El texto visible será el NombreRol
            rolSelect.appendChild(option);
        });
    } catch (error) {
        console.error("Error al cargar los roles:", error);
    }
});



//Fin del método.
/*
// Método para registrar un usuario:
document.getElementById("registroForm").addEventListener("submit", async function (event) {
    event.preventDefault();

    const nombreUsuario = document.getElementById("nombreUsuario").value;
    const contraseña = document.getElementById("contraseña").value;
    const correo = document.getElementById("correo").value;
    const idRol = parseInt(document.getElementById("idRol").value);

    // Automáticamente establecer el estado en 1
    const estado = 1;

    const usuarioDTO = {
        nombre_usuario: nombreUsuario,
        contraseña: contraseña,
        correo_electronico: correo,
        estado: estado,  // Estado establecido automáticamente como 1
        id_rol: idRol
    };

    try {
        const response = await fetch("https://localhost:7046/api/Acceso/Registrarse", {
            method: "POST",
            headers: {
                "Content-Type": "application/json"
            },
            body: JSON.stringify(usuarioDTO)
        });

        const data = await response.json();

        if (response.ok) {
            document.getElementById("mensaje").innerText = data.message;
            document.getElementById("mensaje").style.color = "green"; // Color verde para éxito
        } else {
            document.getElementById("mensaje").innerText = `Error: ${data.message}`;
            document.getElementById("mensaje").style.color = "red"; // Color rojo para errores
        }
    } catch (error) {
        console.error("Error al registrar el usuario:", error);
        document.getElementById("mensaje").innerText = "Ocurrió un error en la conexión.";
        document.getElementById("mensaje").style.color = "red";
    }
});

// Fin del método.
*/



function prueba2(){
    Swal.fire({
    title: "¡Excelente!",
    text: "¡Sesión iniciada con éxito!",
    icon: "success"
    });
    console.log("Sesión iniciada con éxito")
}

// Función para Registrar usuarios:
async function registrarse() {
    // Prevenir el comportamiento por defecto del formulario de recargar la página
    event.preventDefault();
    url1="https://localhost:7046/api/Acceso/Registrarse";
    
    // Obtener los valores de los campos del formulario
    const nombreUsuario = document.getElementById('nombreUsuario').value;
    const contraseña = document.getElementById('contraseña').value;
    const correo = document.getElementById('correo').value;
    const idRol = document.getElementById('idRol').value;
    
    // Crear el objeto usuarioDTO con los valores obtenidos
    const usuarioDTO = {
        Nombre_usuario: nombreUsuario,
        Contraseña: contraseña,
        Correo_electronico: correo,
        Estado: 1, // Asumiendo que siempre será 1 por defecto, cambia esto si es necesario
        Id_rol: parseInt(idRol) // Convertir el idRol a un número
    };
    
    try {
        // Realizar la solicitud al backend
        const response = await fetch('https://localhost:7046/api/Acceso/Registrarse', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
            },
            body: JSON.stringify(usuarioDTO)
        });
        
        // Verificar si la respuesta es exitosa
        if (response.ok) {
            const data = await response.json();
            console.log('Usuario registrado exitosamente:', data);
            Swal.fire({
                title: "¡Excelente!",
                text: "¡Usuario guardado con éxito!",
                icon: "success"
                });
                //Para limpiar el formulario:
                limpiarFormulario();
        } else {
            const errorData = await response.json();
            console.error('Error al registrar usuario:', errorData.message);
            Swal.fire({
                icon: "error",
                title: "Oops...",
                text: "¡Error al registrar el usuario! "+errorData.message,
              });
           
        }
    } catch (error) {
        console.error('Error en la solicitud:', error);
        Swal.fire({
            icon: "error",
            title: "Oops...",
            text: "¡Error al registrar el usuario! "+errorData.message,
          });
    }
}
    //Fin de la función.

    //Función para limpiar el formulario: 
    function limpiarFormulario() {
        document.getElementById('nombreUsuario').value = '';
        document.getElementById('contraseña').value = '';
        document.getElementById('correo').value = '';
        document.getElementById('idRol').value = ''; // Esto seleccionará la opción por defecto
    }


/*Método para el login:*/
//Esto evita que se envíe por defecto el formulario del login
document.addEventListener('DOMContentLoaded', function(){
const loginForm=document.getElementById('loginForm');
loginForm.addEventListener('submit', function(e){
    e.preventDefault();
    loginForm();
});
});

//Función para el login: 
function login(){
    const nombreuser=document.getElementById('nombreuser').value;
    const password=document.getElementById('password').value;
    
    //Variable constante con los datos que se enviarán en formato JSON:
    const loginData={
        Nombre_usuario:nombreuser,
        Contraseña:password
    };
    fetch('https://localhost:7046/api/Acceso/Login',{
        method: 'POST',
        headers:{
            'Content-Type':'application/json',
        },
        body: JSON.stringify(loginData)
    })
    .then(response=>response.json())
    .then(data=>{
        if(data.isSuccess){
            //Cuando el login es exitoso:
            console.log('Login exitoso. Token:',data.token);
            //Lugar donde se guardará el token:
            localStorage.setItem('token',data.token);
            window.location.href='indexcaja.html';
        }else{
            //Cuando el login es fallido:
            console.error('Error:',error);
            alert('Error al conectar con el servidor');
        }
    });
    //Para limpiar el formulario: 
    limpiar();
}

function limpiar(){
    document.getElementById('nombreuser').value='';
    document.getElementById('password').value='';
}
//Fin del método.
