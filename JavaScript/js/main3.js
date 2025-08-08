const form = document.getElementById("formDatos");
const tab = document.getElementById("bodyt");

form.addEventListener("submit", (e) => {
    e.preventDefault();
    let nom = e.target.nombre.value;
    let apel = e.target.apellido.value;
    let con = e.target.contrasenia.value;
    let eda = e.target.edad.value;
    let tel = e.target.telefono.value;

    if(nom.includes(" ")){
        console.log("No cumple");
        alert("No cumple nombre");
    }
    else if(apel.includes(" ")){
        console.log("No cumple");
        alert("No cumple apellido");
    }
    else if(con.length<=6 || con.includes(nom) || con.includes(apel)){
        console.log("No cumple");
        alert("No cumple contraseña");
    }
    else if(eda<10 || eda>100){
        console.log("No cumple");
        alert("No cumple la edad");
    }
    else if(tel.length>10 || tel.length<10){
        console.log("No cumple");
        alert("No cumple telefono");
    }
    else{
        
        tab.innerHTML += `
        <tr>
            <td>${nom}</td>
            <td>${apel}</td>
            <td>${con}</td>
            <td>${eda}</td>
            <td>${tel}</td>
        </tr>`;
    }

  });