const sqlite3 = require('sqlite3').verbose();
const path = require('path');

const dbPath = path.resolve(__dirname, 'cafesense.db');
const db = new sqlite3.Database(dbPath, (err) => {
  if (err) {
    console.error('Error opening database:', err.message);
  } else {
    console.log('Connected to SQLite database at:', dbPath);
    initDatabase();
  }
});

function initDatabase() {
  db.serialize(() => {
    // 1. Table users
    db.run(`
      CREATE TABLE IF NOT EXISTS users (
        id TEXT PRIMARY KEY,
        email TEXT UNIQUE NOT NULL,
        password TEXT NOT NULL,
        avatar TEXT,
        occupation TEXT,
        main_purpose TEXT,
        companion TEXT,
        noise_level TEXT,
        wifi_need TEXT,
        amenities TEXT,
        space_style TEXT,
        value_priorities TEXT,
        preferred_light TEXT,
        preferred_music TEXT,
        preferred_cafe_size TEXT,
        preferred_cafe_view TEXT,
        preferred_concepts TEXT,
        flavor_preference TEXT,
        created_at TEXT
      )
    `);

    // 2. Table cafes
    db.run(`
      CREATE TABLE IF NOT EXISTS cafes (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        description TEXT,
        image_url TEXT,
        latitude REAL,
        longitude REAL,
        price_label TEXT,
        tagline TEXT,
        space_styles TEXT, -- comma-separated list of styles
        amenities TEXT,    -- comma-separated list of amenities
        roast_level TEXT,
        acidity TEXT,
        body TEXT,
        sweetness TEXT,
        process TEXT
      )
    `, () => {
      seedCafes();
    });

    // 3. Table menu_items
    db.run(`
      CREATE TABLE IF NOT EXISTS menu_items (
        id TEXT PRIMARY KEY,
        cafe_id TEXT,
        name TEXT NOT NULL,
        price REAL,
        category TEXT,
        FOREIGN KEY (cafe_id) REFERENCES cafes (id) ON DELETE CASCADE
      )
    `, () => {
      seedMenuItems();
    });

    // 4. Table reviews
    db.run(`
      CREATE TABLE IF NOT EXISTS reviews (
        id TEXT PRIMARY KEY,
        cafe_id TEXT,
        user_id TEXT,
        user_name TEXT,
        user_avatar TEXT,
        rating REAL,
        comment TEXT,
        created_at TEXT,
        FOREIGN KEY (cafe_id) REFERENCES cafes (id) ON DELETE CASCADE
      )
    `, () => {
      seedReviews();
    });
  });
}

function seedCafes() {
  db.get("SELECT COUNT(*) as count FROM cafes", (err, row) => {
    if (err) return console.error(err);
    if (row.count === 0) {
      console.log("Seeding cafes data...");
      const stmt = db.prepare(`
        INSERT INTO cafes (id, name, description, image_url, latitude, longitude, price_label, tagline, space_styles, amenities, roast_level, acidity, body, sweetness, process)
        VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
      `);

      stmt.run(
        "1",
        "The Gilded Bean",
        "Một nơi trú ẩn cho công việc tập trung với cà phê rang tại nhà và khu vực yên tĩnh.",
        "https://images.unsplash.com/photo-1497935586351-b67a49e012bf?w=1000&q=80",
        16.0597,
        108.2225,
        "$$",
        "Best for: Deep Work",
        "Ấm cúng,Hiện đại",
        "Thức ăn nhẹ,Thức uống đa dạng,Toilet sạch,Ghế thoải mái,Điều hòa tốt,Sạc điện thoại",
        "Medium",
        "Low",
        "Medium",
        "High",
        "Washed"
      );

      stmt.run(
        "2",
        "Velvet Roast",
        "Không gian mềm ánh sáng, hợp cho đọc sách và trò chuyện nhẹ nhàng.",
        "https://images.unsplash.com/photo-1541167760496-1628856ab772?w=1000&q=80",
        16.0618,
        108.2240,
        "$$",
        "Best for: Soft Focus",
        "Vintage,Ấm cúng",
        "Thức uống đa dạng,Toilet sạch,Ghế thoải mái,Điều hòa tốt,Không gian mở",
        "Medium-Dark",
        "Low",
        "High",
        "Medium",
        "Natural"
      );

      stmt.run(
        "3",
        "Obsidian Brew",
        "Concept tối giản, roast đậm, có nhiều bàn nhỏ cho làm việc 1-1.",
        "https://images.unsplash.com/photo-1514432324607-a09d9b4aefdd?w=1000&q=80",
        16.0565,
        108.2106,
        "$$$",
        "Best for: Espresso Lovers",
        "Hiện đại",
        "Thức uống đa dạng,Ghế thoải mái,Sạc điện thoại,Điều hòa tốt",
        "Dark",
        "None",
        "High",
        "Low",
        "Natural"
      );

      stmt.run(
        "4",
        "Flora & Foam",
        "Nhiều cây xanh, ánh sáng tự nhiên, hợp brainstorming sáng tạo.",
        "https://images.unsplash.com/photo-1525648199074-cee30ba79a4a?w=1000&q=80",
        16.0504,
        108.2364,
        "$$",
        "Best for: Creative Brainstorming",
        "Thiên nhiên",
        "Thức uống đa dạng,Toilet sạch,Điều hòa tốt,Không gian mở",
        "Light",
        "High",
        "Low",
        "High",
        "Washed"
      );

      stmt.finalize();
      console.log("Cafes seeded successfully.");
    }
  });
}

function seedMenuItems() {
  db.get("SELECT COUNT(*) as count FROM menu_items", (err, row) => {
    if (err) return console.error(err);
    if (row.count === 0) {
      console.log("Seeding menu items...");
      const stmt = db.prepare(`
        INSERT INTO menu_items (id, cafe_id, name, price, category)
        VALUES (?, ?, ?, ?, ?)
      `);

      // Cafe 1 items
      stmt.run("m1", "1", "Espresso", 35000, "Coffee");
      stmt.run("m2", "1", "Latte", 45000, "Coffee");
      stmt.run("m3", "1", "Croissant Bơ", 25000, "Cake");

      // Cafe 2 items
      stmt.run("m4", "2", "Cappuccino", 45000, "Coffee");
      stmt.run("m5", "2", "Trà Đào Cam Sả", 40000, "Tea");
      stmt.run("m6", "2", "Tiramisu", 35000, "Cake");

      // Cafe 3 items
      stmt.run("m7", "3", "Cold Brew", 48000, "Coffee");
      stmt.run("m8", "3", "Flat White", 50000, "Coffee");

      // Cafe 4 items
      stmt.run("m9", "4", "Pour Over V60", 55000, "Coffee");
      stmt.run("m10", "4", "Trà Hoa Cúc Mật Ong", 42000, "Tea");

      stmt.finalize();
      console.log("Menu items seeded successfully.");
    }
  });
}

function seedReviews() {
  db.get("SELECT COUNT(*) as count FROM reviews", (err, row) => {
    if (err) return console.error(err);
    if (row.count === 0) {
      console.log("Seeding reviews...");
      const stmt = db.prepare(`
        INSERT INTO reviews (id, cafe_id, user_id, user_name, user_avatar, rating, comment, created_at)
        VALUES (?, ?, ?, ?, ?, ?, ?, ?)
      `);

      stmt.run("r1", "1", "user_admin", "Hoàng Nam", "🧑", 5.0, "Không gian tuyệt vời để tập trung code. Wifi siêu nhanh và yên tĩnh.", new Date().toISOString());
      stmt.run("r2", "1", "user_2", "Linh Chi", "👩", 4.0, "Đồ uống ổn, quán hơi đông vào giờ chiều nhưng mọi người giữ trật tự tốt.", new Date().toISOString());
      stmt.run("r3", "2", "user_3", "Quốc Anh", "👨", 4.5, "Nhạc jazz rất hay, ánh sáng dịu thích hợp để đọc sách và thư giãn cuối tuần.", new Date().toISOString());
      stmt.run("r4", "3", "user_admin", "Hoàng Nam", "🧑", 5.0, "Cà phê specialty rang cực chuẩn vị. Concept tối giản hiện đại.", new Date().toISOString());
      stmt.run("r5", "4", "user_4", "Minh Thư", "👩", 4.5, "Quán nhiều cây xanh mát mẻ, chụp ảnh checkin rất đẹp. Nhân viên thân thiện.", new Date().toISOString());

      stmt.finalize();
      console.log("Reviews seeded successfully.");
    }
  });
}

module.exports = db;
