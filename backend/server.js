const express = require('express');
const cors = require('cors');
const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');
const db = require('./db');
const { calculateMatch } = require('./matching');

const app = express();
const PORT = process.env.PORT || 3000;
const JWT_SECRET = 'cafesense_super_secret_key';

// Middlewares
app.use(cors());
app.use(express.json());

// Auth Middleware
function authenticateToken(req, res, next) {
  const authHeader = req.headers.authorization;
  if (!authHeader || !authHeader.startsWith('Bearer ')) {
    return res.status(401).json({ error: 'Access token required' });
  }

  const token = authHeader.substring(7);
  try {
    const decoded = jwt.verify(token, JWT_SECRET);
    req.userId = decoded.id;
    next();
  } catch (err) {
    return res.status(403).json({ error: 'Invalid or expired token' });
  }
}

// 1. Auth: Register
app.post('/api/auth/register', (req, res) => {
  const { email, password } = req.body;
  if (!email || !password) {
    return res.status(400).json({ error: "Email and password are required" });
  }

  // Check if email already exists
  db.get("SELECT id FROM users WHERE email = ?", [email], (err, row) => {
    if (err) return res.status(500).json({ error: err.message });
    if (row) return res.status(400).json({ error: "Email is already registered" });

    const hashedPassword = bcrypt.hashSync(password, 8);
    const userId = Date.now().toString(); // simple unique ID
    const createdAt = new Date().toISOString();

    db.run(
      "INSERT INTO users (id, email, password, created_at) VALUES (?, ?, ?, ?)",
      [userId, email, hashedPassword, createdAt],
      function(err) {
        if (err) return res.status(500).json({ error: err.message });

        const token = jwt.sign({ id: userId, email }, JWT_SECRET, { expiresIn: '7d' });
        res.status(201).json({
          id: userId,
          email,
          token
        });
      }
    );
  });
});

// 2. Auth: Login
app.post('/api/auth/login', (req, res) => {
  const { email, password } = req.body;
  if (!email || !password) {
    return res.status(400).json({ error: "Email and password are required" });
  }

  db.get("SELECT * FROM users WHERE email = ?", [email], (err, user) => {
    if (err) return res.status(500).json({ error: err.message });
    if (!user) return res.status(400).json({ error: "Invalid email or password" });

    const isValid = bcrypt.compareSync(password, user.password);
    if (!isValid) return res.status(400).json({ error: "Invalid email or password" });

    const token = jwt.sign({ id: user.id, email: user.email }, JWT_SECRET, { expiresIn: '7d' });
    
    let profile = null;
    if (user.avatar || user.occupation) {
      try {
        profile = {
          avatar: user.avatar || '',
          occupation: user.occupation || '',
          mainPurpose: user.main_purpose || '',
          companion: user.companion || '',
          noiseLevel: user.noise_level || '',
          wifiNeed: user.wifi_need || '',
          amenities: user.amenities ? JSON.parse(user.amenities) : [],
          spaceStyle: user.space_style ? JSON.parse(user.space_style) : [],
          valuePriorities: user.value_priorities ? JSON.parse(user.value_priorities) : [],
          preferredLight: user.preferred_light || '',
          preferredMusic: user.preferred_music || '',
          preferredCafeSize: user.preferred_cafe_size || '',
          preferredCafeView: user.preferred_cafe_view || '',
          preferredConcepts: user.preferred_concepts ? JSON.parse(user.preferred_concepts) : [],
          flavorPreference: user.flavor_preference ? JSON.parse(user.flavor_preference) : {}
        };
      } catch (e) {
        console.error("Error parsing user profile:", e);
      }
    }

    res.json({
      id: user.id,
      email: user.email,
      token,
      profile
    });
  });
});

// 3. Save survey / onboarding profile
app.post('/api/profile', authenticateToken, (req, res) => {
  const userId = req.userId;
  const p = req.body;

  db.run(
    `UPDATE users SET 
      avatar = ?,
      occupation = ?,
      main_purpose = ?,
      companion = ?,
      noise_level = ?,
      wifi_need = ?,
      amenities = ?,
      space_style = ?,
      value_priorities = ?,
      preferred_light = ?,
      preferred_music = ?,
      preferred_cafe_size = ?,
      preferred_cafe_view = ?,
      preferred_concepts = ?,
      flavor_preference = ?
    WHERE id = ?`,
    [
      p.avatar || '',
      p.occupation || '',
      p.mainPurpose || '',
      p.companion || '',
      p.noiseLevel || '',
      p.wifiNeed || '',
      JSON.stringify(p.amenities || []),
      JSON.stringify(p.spaceStyle || []),
      JSON.stringify(p.valuePriorities || []),
      p.preferredLight || '',
      p.preferredMusic || '',
      p.preferredCafeSize || '',
      p.preferredCafeView || '',
      JSON.stringify(p.preferredConcepts || []),
      JSON.stringify(p.flavorPreference || {}),
      userId
    ],
    function(err) {
      if (err) return res.status(500).json({ error: err.message });
      res.json({ message: "Profile updated successfully" });
    }
  );
});

// 4. Get all cafes
app.get('/api/cafes', (req, res) => {
  db.all("SELECT * FROM cafes", [], (err, cafes) => {
    if (err) return res.status(500).json({ error: err.message });
    
    db.all("SELECT * FROM menu_items", [], (err, menuItems) => {
      if (err) return res.status(500).json({ error: err.message });
      
      db.all("SELECT * FROM reviews ORDER BY created_at DESC", [], (err, reviews) => {
        if (err) return res.status(500).json({ error: err.message });
        
        const result = cafes.map(cafe => {
          return {
            id: cafe.id,
            name: cafe.name,
            description: cafe.description,
            imageUrl: cafe.image_url,
            latitude: cafe.latitude,
            longitude: cafe.longitude,
            priceLabel: cafe.price_label,
            tagline: cafe.tagline,
            spaceStyle: cafe.space_styles ? cafe.space_styles.split(',') : [],
            amenities: cafe.amenities ? cafe.amenities.split(',') : [],
            menu: menuItems.filter(item => item.cafe_id === cafe.id).map(item => ({
              name: item.name,
              price: item.price,
              category: item.category
            })),
            reviews: reviews.filter(rev => rev.cafe_id === cafe.id).map(rev => ({
              id: rev.id,
              userName: rev.user_name,
              userAvatar: rev.user_avatar,
              rating: rev.rating,
              comment: rev.comment,
              dateTime: rev.created_at
            }))
          };
        });
        res.json(result);
      });
    });
  });
});

// 5. Get cafe by ID
app.get('/api/cafes/:id', (req, res) => {
  const cafeId = req.params.id;
  db.get("SELECT * FROM cafes WHERE id = ?", [cafeId], (err, cafe) => {
    if (err) return res.status(500).json({ error: err.message });
    if (!cafe) return res.status(404).json({ error: "Cafe not found" });
    
    db.all("SELECT * FROM menu_items WHERE cafe_id = ?", [cafeId], (err, menuItems) => {
      if (err) return res.status(500).json({ error: err.message });
      db.all("SELECT * FROM reviews WHERE cafe_id = ? ORDER BY created_at DESC", [cafeId], (err, reviews) => {
        if (err) return res.status(500).json({ error: err.message });
        
        res.json({
          id: cafe.id,
          name: cafe.name,
          description: cafe.description,
          imageUrl: cafe.image_url,
          latitude: cafe.latitude,
          longitude: cafe.longitude,
          priceLabel: cafe.price_label,
          tagline: cafe.tagline,
          spaceStyle: cafe.space_styles ? cafe.space_styles.split(',') : [],
          amenities: cafe.amenities ? cafe.amenities.split(',') : [],
          menu: menuItems.map(item => ({
            name: item.name,
            price: item.price,
            category: item.category
          })),
          reviews: reviews.map(rev => ({
            id: rev.id,
            userName: rev.user_name,
            userAvatar: rev.user_avatar,
            rating: rev.rating,
            comment: rev.comment,
            dateTime: rev.created_at
          }))
        });
      });
    });
  });
});

// 6. Post review for cafe
app.post('/api/cafes/:id/reviews', authenticateToken, (req, res) => {
  const userId = req.userId;
  const cafeId = req.params.id;
  const { rating, comment } = req.body;

  if (rating === undefined || !comment) {
    return res.status(400).json({ error: "Rating and comment are required" });
  }
  
  db.get("SELECT email, avatar FROM users WHERE id = ?", [userId], (err, user) => {
    if (err || !user) return res.status(404).json({ error: "User not found" });
    
    const userName = user.email.split('@')[0];
    const userAvatar = user.avatar || "🧑";
    const reviewId = Date.now().toString();
    const createdAt = new Date().toISOString();
    
    db.run(
      "INSERT INTO reviews (id, cafe_id, user_id, user_name, user_avatar, rating, comment, created_at) VALUES (?, ?, ?, ?, ?, ?, ?, ?)",
      [reviewId, cafeId, userId, userName, userAvatar, rating, comment, createdAt],
      function(err) {
        if (err) return res.status(500).json({ error: err.message });
        res.status(201).json({
          id: reviewId,
          userName,
          userAvatar,
          rating: Number(rating),
          comment,
          dateTime: createdAt
        });
      }
    );
  });
});

// 7. Get cafes sorted by match score
app.post('/api/match', (req, res) => {
  let userProfile = req.body;
  
  const runMatching = (profile) => {
    db.all("SELECT * FROM cafes", [], (err, cafes) => {
      if (err) return res.status(500).json({ error: err.message });
      
      db.all("SELECT * FROM menu_items", [], (err, menuItems) => {
        if (err) return res.status(500).json({ error: err.message });
        
        db.all("SELECT * FROM reviews ORDER BY created_at DESC", [], (err, reviews) => {
          if (err) return res.status(500).json({ error: err.message });
          
          const matchedCafes = cafes.map(cafe => {
            const fullCafe = {
              id: cafe.id,
              name: cafe.name,
              description: cafe.description,
              imageUrl: cafe.image_url,
              latitude: cafe.latitude,
              longitude: cafe.longitude,
              priceLabel: cafe.price_label,
              tagline: cafe.tagline,
              spaceStyle: cafe.space_styles ? cafe.space_styles.split(',') : [],
              amenities: cafe.amenities ? cafe.amenities.split(',') : [],
              menu: menuItems.filter(item => item.cafe_id === cafe.id).map(item => ({
                name: item.name,
                price: item.price,
                category: item.category
              })),
              reviews: reviews.filter(rev => rev.cafe_id === cafe.id).map(rev => ({
                id: rev.id,
                userName: rev.user_name,
                userAvatar: rev.user_avatar,
                rating: rev.rating,
                comment: rev.comment,
                dateTime: rev.created_at
              })),
              // Cafe properties used in matching:
              roast_level: cafe.roast_level,
              acidity: cafe.acidity,
              body: cafe.body,
              sweetness: cafe.sweetness,
              process: cafe.process
            };
            
            const matchPercent = calculateMatch(profile, fullCafe);
            
            // Cleanup internal matching keys before response
            delete fullCafe.roast_level;
            delete fullCafe.acidity;
            delete fullCafe.body;
            delete fullCafe.sweetness;
            delete fullCafe.process;
            
            return {
              ...fullCafe,
              matchPercent
            };
          });
          
          matchedCafes.sort((a, b) => b.matchPercent - a.matchPercent);
          res.json(matchedCafes);
        });
      });
    });
  };
  
  if (userProfile && Object.keys(userProfile).length > 0 && userProfile.avatar !== undefined) {
    runMatching(userProfile);
  } else {
    const authHeader = req.headers.authorization;
    if (authHeader && authHeader.startsWith('Bearer ')) {
      const token = authHeader.substring(7);
      try {
        const decoded = jwt.verify(token, JWT_SECRET);
        const userId = decoded.id;
        db.get("SELECT * FROM users WHERE id = ?", [userId], (err, user) => {
          if (err || !user) {
            return res.status(404).json({ error: "User profile not found" });
          }
          
          let dbProfile = null;
          try {
            dbProfile = {
              avatar: user.avatar || '',
              occupation: user.occupation || '',
              mainPurpose: user.main_purpose || '',
              companion: user.companion || '',
              noiseLevel: user.noise_level || '',
              wifiNeed: user.wifi_need || '',
              amenities: user.amenities ? JSON.parse(user.amenities) : [],
              spaceStyle: user.space_style ? JSON.parse(user.space_style) : [],
              valuePriorities: user.value_priorities ? JSON.parse(user.value_priorities) : [],
              preferredLight: user.preferred_light || '',
              preferredMusic: user.preferred_music || '',
              preferredCafeSize: user.preferred_cafe_size || '',
              preferredCafeView: user.preferred_cafe_view || '',
              preferredConcepts: user.preferred_concepts ? JSON.parse(user.preferred_concepts) : [],
              flavorPreference: user.flavor_preference ? JSON.parse(user.flavor_preference) : {}
            };
          } catch (e) {
            console.error("Error parsing user profile from DB:", e);
            dbProfile = {};
          }
          
          runMatching(dbProfile);
        });
      } catch (e) {
        return res.status(401).json({ error: "Invalid token" });
      }
    } else {
      return res.status(400).json({ error: "User profile or Bearer token is required" });
    }
  }
});

// Start server
app.listen(PORT, () => {
  console.log(`CafeSense server running on http://localhost:${PORT}`);
});
