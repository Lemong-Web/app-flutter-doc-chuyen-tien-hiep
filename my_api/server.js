const express = require('express');
const bodyParser = require('body-parser');
const cors = require('cors');

const app = express();
app.use(cors());
app.use(bodyParser.json());

let Book = [
    {name: 'Book A', genre: 'A'},
    {name: 'Book B', genre: 'B'}
];

app.get('/Book', (req, res) => {
   res.json(Book);
});

app.post('/addBook', (req, res) => {
  const newBook = req.body;
  Book.push ({ id: Book.length + 1, ...newBook});
  res.json({ message: 'Thêm Book', Book});
});

app.listen(3000, () => console.log('Server chạy tại http://localhost:3000'))