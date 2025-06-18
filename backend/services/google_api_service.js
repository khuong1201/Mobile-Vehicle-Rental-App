const axios = require('axios');
const GOOGLE_API_KEY = process.env.GOOGLE_API_KEY;

// 🔍 1. Tìm kiếm địa điểm theo từ khóa (Text Search API)
const searchPlace = async (req, res) => {
  const { keyword } = req.body;

  if (!keyword) return res.status(400).json({ error: 'Thiếu từ khóa tìm kiếm (keyword)' });

  const url = `https://maps.googleapis.com/maps/api/place/textsearch/json?query=${encodeURIComponent(keyword)}&key=${GOOGLE_API_KEY}`;

  try {
    const response = await axios.get(url);
    const places = response.data.results.map(place => ({
      name: place.name,
      address: place.formatted_address,
      location: place.geometry.location
    }));
    res.json(places);
  } catch (error) {
    console.error('❌ Lỗi gọi Google Place API:', error.message);
    res.status(500).json({ error: 'Lỗi khi tìm kiếm địa điểm' });
  }
};

// 📍 2. Lấy địa chỉ từ tọa độ (Reverse Geocoding API)
const reverseGeocode = async (req, res) => {
  const { lat, lng } = req.body;

  if (!lat || !lng) return res.status(400).json({ error: 'Thiếu lat hoặc lng' });

  const url = `https://maps.googleapis.com/maps/api/geocode/json?latlng=${lat},${lng}&key=${GOOGLE_API_KEY}`;

  try {
    const response = await axios.get(url);
    const results = response.data.results;

    if (!results.length) {
      return res.status(404).json({ error: 'Không tìm thấy địa chỉ' });
    }

    res.json({
      formatted_address: results[0].formatted_address,
      raw: results
    });
  } catch (error) {
    console.error('❌ Lỗi gọi Geocoding API:', error.message);
    res.status(500).json({ error: 'Lỗi khi gọi Geocoding API' });
  }
};

// 📌 3. Lấy tọa độ từ địa chỉ (Forward Geocoding API)
const forwardGeocode = async (req, res) => {
  const { address } = req.body;

  if (!address) return res.status(400).json({ error: 'Thiếu địa chỉ' });

  const url = `https://maps.googleapis.com/maps/api/geocode/json?address=${encodeURIComponent(address)}&key=${GOOGLE_API_KEY}`;

  try {
    const response = await axios.get(url);
    const result = response.data.results[0];

    if (!result) return res.status(404).json({ error: 'Không tìm thấy tọa độ' });

    res.json({
      formatted_address: result.formatted_address,
      location: result.geometry.location,
      raw: result
    });
  } catch (err) {
    console.error('❌ Lỗi forward geocoding:', err.message);
    res.status(500).json({ error: 'Lỗi khi gọi forward geocoding API' });
  }
};

module.exports = {
  searchPlace,
  reverseGeocode,
  forwardGeocode
};
