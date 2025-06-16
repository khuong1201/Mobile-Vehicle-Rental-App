const mongoose = require('mongoose');
const Brand = require('../../models/vehicles/brand_model');

// Get all brands
const GetAllBrands = async (req, res) => {
  try {
    const brands = await Brand.find();
    res.status(200).json({ success: true, data: brands });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: 'Error retrieving brand list',
      error: error.message
    });
  }
};

const GetBrandByBrandId = async (req, res) => {
  try {
    const { brandId } = req.params;
    const brand = await Brand.findOne({ brandId });

    if (!brand) {
      return res.status(404).json({
        success: false,
        message: `Brand with brandId: ${brandId} not found`
      });
    }

    res.status(200).json({ success: true, data: brand });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: 'Error retrieving brand',
      error: error.message
    });
  }
};

const CreateBrand = async (req, res) => {
  try {
    const { brandName, brandLogo } = req.body;

    if (!req.body) {
      return res.status(400).json({
        success: false,
        message: 'Please provide a brand name and logo'
      });
    }

    const existed = await Brand.findOne({ brandName });
    if (existed) {
      return res.status(400).json({
        success: false,
        message: 'Brand already exists'
      });
    }

    const newBrand = await Brand.create({ brandName, brandLogo });
    res.status(201).json({
      success: true,
      data: newBrand,
      message: 'Brand created successfully'
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: 'Error creating brand',
      error: error.message
    });
  }
};

const UpdateBrand = async (req, res) => {
  try {
    const { id } = req.params;
    const { brandName, brandLogo } = req.body;

    if (!mongoose.Types.ObjectId.isValid(id)) {
      return res.status(400).json({ success: false, message: 'Invalid ID' });
    }

    const updated = await Brand.findByIdAndUpdate(id, { brandName, brandLogo }, { new: true, runValidators: true });

    if (!updated) {
      return res.status(404).json({ success: false, message: 'Brand not found' });
    }

    res.status(200).json({ success: true, data: updated, message: 'Brand updated successfully' });
  } catch (error) {
    res.status(500).json({ success: false, message: 'Error updating brand', error: error.message });
  }
};

const DeleteBrand = async (req, res) => {
  try {
    const { id } = req.params;

    if (!mongoose.Types.ObjectId.isValid(id)) {
      return res.status(400).json({ success: false, message: 'Invalid ID' });
    }

    const deleted = await Brand.findByIdAndDelete(id);

    if (!deleted) {
      return res.status(404).json({ success: false, message: 'Brand not found' });
    }

    res.status(200).json({ success: true, message: 'Brand deleted successfully' });
  } catch (error) {
    res.status(500).json({ success: false, message: 'Error deleting brand', error: error.message });
  }
};

module.exports = {
  GetAllBrands,
  GetBrandByBrandId,
  CreateBrand,
  UpdateBrand,
  DeleteBrand
};
