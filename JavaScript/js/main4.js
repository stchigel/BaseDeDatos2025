const form = document.getElementById("formDatos");
const tab = document.getElementById("bodyt");

form.addEventListener("submit", (e) => {
    e.preventDefault();
    let nom = e.target.nombre.value;
    let apel = e.target.apellido.value;

    if(!nom.trim()){
        console.log("No cumple");
        alert("Ingresa un producto");
    }
    else if(apel<1){
        console.log("No cumple");
        alert("No cumple la cantidad minima");
    }
    else if(apel>10){
        console.log("No cumple");
        alert("No cumple la cantidad maxima");
    }
    else{
        let trnuevo = document.createElement("tr");
        trnuevo.innerHTML = `
        <td>${nom}</td>
        <td>${apel}</td>
        <td><button onclick="eliminarFila(this)" class="btn btn-primary">Eliminar</button></td>`;
        tab.appendChild(trnuevo);
    }

    
  });
  
  function eliminarFila(boton) {
        let fila = boton.closest("tr"); 
        fila.remove();
    }