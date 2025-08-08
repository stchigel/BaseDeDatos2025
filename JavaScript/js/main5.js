async function traerDatos() {
    const respuesta = await fetch('https://www.scorebat.com/video-api/v3/feed/?token=MjI0NDgyXzE3NTQ2NjQzNjBfZmJkZjkxYTI5Y2E1MjZkZmY3NGViNTNmOTI3NTllNGMxMjI5ZTUyZg==');
    const datos = await respuesta.json();
    return datos;
}
const datos = traerDatos();
const divc = document.getElementById("divCards");

datos.forEach(post => {
    console.log(post);
    divc.innerHTML += `
            <div class="card col-3" style="width: 18rem;">
                <img src="${post.thumbnail}" class="card-img-top" alt="${post.title}">
                <div class="card-body">
                    <h5 class="card-title">${post.title}</h5>
                    <p class="card-text">${post.competition}</a>
                </div>
            </div>
    `
  });