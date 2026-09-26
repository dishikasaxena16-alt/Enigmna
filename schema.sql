-- Database Schema for StockSense

CREATE TABLE IF NOT EXISTS locations (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL UNIQUE
);

CREATE TABLE IF NOT EXISTS categories (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL UNIQUE
);

CREATE TABLE IF NOT EXISTS products (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL,
    sku TEXT UNIQUE NOT NULL,
    category_id INTEGER REFERENCES categories(id),
    unit_of_measure TEXT NOT NULL DEFAULT 'units',
    reorder_level REAL DEFAULT 10
);

CREATE TABLE IF NOT EXISTS stock_levels (
    product_id INTEGER REFERENCES products(id),
    location_id INTEGER REFERENCES locations(id),
    quantity REAL DEFAULT 0,
    PRIMARY KEY (product_id, location_id)
);

CREATE TABLE IF NOT EXISTS stock_moves (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    type TEXT CHECK(type IN ('RECEIPT', 'DELIVERY', 'TRANSFER', 'ADJUSTMENT')) NOT NULL,
    status TEXT CHECK(status IN ('Draft', 'Ready', 'Done', 'Canceled')) DEFAULT 'Draft',
    source_location_id INTEGER REFERENCES locations(id),
    dest_location_id INTEGER REFERENCES locations(id),
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS stock_move_items (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    move_id INTEGER REFERENCES stock_moves(id) ON DELETE CASCADE,
    product_id INTEGER REFERENCES products(id),
    quantity REAL NOT NULL
);

CREATE TABLE IF NOT EXISTS stock_ledger (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    move_id INTEGER REFERENCES stock_moves(id),
    product_id INTEGER REFERENCES products(id),
    source_location_id INTEGER REFERENCES locations(id),
    dest_location_id INTEGER REFERENCES locations(id),
    qty_changed REAL NOT NULL,
    timestamp DATETIME DEFAULT CURRENT_TIMESTAMP
);



