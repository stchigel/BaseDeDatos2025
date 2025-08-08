const input = document.getElementById("exampleInput");
const subm = document.getElementById("aceptar");

subm.addEventListener("click", () => {
    let inpval = input.value;
    if(inpval[0]=='#' && inpval.length == 7){
        circulo.style = "background-color:"+inpval;
    }else{
        console.log("No cumple bobi");
        alert("No cumple bobi");
    }
  });


document.getElementById("formColor").addEventListener("submit", (event) => {
    event.preventDefault();
  });