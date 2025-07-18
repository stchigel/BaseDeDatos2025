const express = require('express')
const mysql = require('mysql2');
const bodyParser = require('body-parser');

const hostname = '127.0.0.1';
const app = express()
const port = 3000

app.use(bodyParser.urlencoded({ extended: true }));
app.use(express.static('public')); 

const db = mysql.createConnection({
    host: 'localhost',
    user: 'alumno',
    password: 'alumnoipm',
    database: 'reservas'
  });

db.connect((err) => {
    if (err) throw err;
    console.log('Conectado a la base de datos.');
});

app.post('/compra', (req, res) => {
    const checkin = req.body.checkin_date;
    const checkout = req.body.checkout_date;
    const adults = req.body.adults;
    const children = req.body.children;
    const card = req.body.card;
    const cvv = req.body.cvv;
  
    db.query(`INSERT INTO Compra (checkIN, checkOUT, adults, children, card, cvv) VALUES 
        ("${checkin}","${checkout}","${adults}",
        "${children}","${card}","${cvv}")`, (err, result) => {
      if (err) throw err;
      console.log('Reserva agregada:', result.insertId);

      res.redirect('/graciasCompra.html');
    });
    db.end; 
    console.log("anda");
  });

app.listen(port, hostname, () => {
    console.log(`Servidor funcionando en http://${hostname}:${port}/`);
  });