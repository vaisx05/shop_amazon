const express = require('express');
const cors = require('cors');
const { Pool } = require('pg');

const app = express();
app.use(cors());
app.use(express.json());

const pool = new Pool({
  user: 'postgres',
  host: 'localhost',
  database: 'shoppingapp',
  password: '2004', 
  port: 5432,
});


app.get('/products', async (req, res) => {
  try {
    const result = await pool.query('SELECT * FROM products');
    res.json(result.rows);
  } catch (error) {
    console.error('Error fetching products:', error);
    res.status(500).send('Server error');
  }
});


app.put('/products/:id/like', async (req, res) => {
  const { id } = req.params;
  const { liked } = req.body;

  try {
    const result = await pool.query(
      'UPDATE products SET liked = $1 WHERE id = $2 RETURNING *',
      [liked, id]
    );

    if (result.rowCount === 0) {
      return res.status(404).json({ message: 'Product not found' });
    }

    res.status(200).json({
      message: 'Product liked status updated successfully',
      product: result.rows[0],
    });
  } catch (error) {
    console.error('Error updating liked status:', error);
    res.status(500).json({ error: 'Failed to update liked status' });
  }
});


app.get('/products/cart', async (req, res) => {
  try {
    const result = await pool.query('SELECT * FROM products WHERE in_cart = true');
    res.json(result.rows);
  } catch (error) {
    console.error('Error fetching cart products:', error);
    res.status(500).send('Server error');
  }
});


app.put('/products/:id/cart', async (req, res) => {
  const { id } = req.params;
  const { in_cart } = req.body;

  try {
    const result = await pool.query(
      'UPDATE products SET in_cart = $1 WHERE id = $2 RETURNING *',
      [in_cart, id]
    );

    if (result.rowCount === 0) {
      return res.status(404).json({ message: 'Product not found' });
    }

    res.status(200).json({
      message: 'Product cart status updated successfully',
      product: result.rows[0],
    });
  } catch (error) {
    console.error('Error updating cart status:', error);
    res.status(500).json({ error: 'Failed to update cart status' });
  }
});


app.get('/products/buy', async (req, res) => {
  try {
    const result = await pool.query('SELECT * FROM products WHERE buy = true');
    res.json(result.rows);
  } catch (error) {
    console.error('Error fetching purchased products:', error);
    res.status(500).send('Server error');
  }
});


app.put('/products/:id/buy', async (req, res) => {
  const { id } = req.params;
  const { buy } = req.body;

  try {
    const result = await pool.query(
      'UPDATE products SET buy = $1 WHERE id = $2 RETURNING *',
      [buy, id]
    );

    if (result.rowCount === 0) {
      return res.status(404).json({ message: 'Product not found' });
    }

    res.status(200).json({
      message: 'Product purchase status updated successfully',
      product: result.rows[0],
    });
  } catch (error) {
    console.error('Error updating purchase status:', error);
    res.status(500).json({ error: 'Failed to update purchase status' });
  }
});

const PORT = 5000;
app.listen(PORT, () => {
  console.log(`Server is running on port ${PORT}`);
});
