let click=false;
const circ = document.getElementById("circulo");

circ.addEventListener("click", () => {
    if(!click){
        circulo.style = "background-color:#ff0000";
        click=true;
    }
    else{
        circulo.style = "background-color:#808080";
        click=false;
    }
  });
  