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
        tab.innerHTML += `
        <tr>
            <td>${nom}</td>
            <td>${apel}</td>
            <td>Eliminar</td>
        </tr>`;
    }

    document.addEventListener("click", function(e) {
        if (e.target.classList.contains("eliminar")) {
          const fila = e.target.closest("tr");
          fila.remove();
        }
      });

  });