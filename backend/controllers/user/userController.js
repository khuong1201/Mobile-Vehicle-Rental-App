const bcrypt = require('bcrypt');
const User = require('../../models/user_model');

// Change Password
const changePassword = async (req, res) => {
  try {
    const { oldPassword, newPassword } = req.body;
    if (!oldPassword || !newPassword) {
      return res.status(400).json({ message: 'oldPassword and newPassword are required' });
    }
    if (newPassword.length < 8) {
      return res.status(400).json({ message: 'New password must be at least 8 characters' });
    }

    const user = await User.findById(req.user.id);
    if (!user) {
      return res.status(404).json({ message: 'User not found' });
    }

    if (!user.passwordHash) {
      return res.status(400).json({ message: 'Use Google login or reset password' });
    }

    const isMatch = await bcrypt.compare(oldPassword, user.passwordHash);
    if (!isMatch) {
      return res.status(400).json({ message: 'Incorrect old password' });
    }

    const passwordHash = await bcrypt.hash(newPassword, 10);
    user.passwordHash = passwordHash;
    await user.save();

    res.json({ message: 'Password changed successfully' });
  } catch (err) {
    console.error('Change password error:', err.message);
    res.status(400).json({ message: err.message });
  }
};

// Delete Account
const deleteAccount = async (req, res) => {
  try {
    const user = await User.findById(req.user.id);
    if (!user) {
      return res.status(404).json({ message: 'User not found' });
    }

    await User.deleteOne({ _id: user._id });
    res.json({ message: 'Account deleted successfully' });
  } catch (err) {
    console.error('Delete account error:', err.message);
    res.status(400).json({ message: err.message });
  }
};

const updatePersonalInfo = async (req, res) => {
  try{
    if (!req.body) {
      return res.status(400).json({ message: 'Request body is missing' });
    }
    const {fullName, dateOfBirth, phoneNumber, gender, IDs} = req.body;
    if(!fullName){
      return res.status(400).json({ message: 'Full name is required' });
    }else if(fullName.length < 3){
      return res.status(400).json({ message: 'Full name must be at least 3 characters long' });
    }else if(!dateOfBirth){
      return res.status(400).json({ message: 'Date of birth is required' });
    }else if(!phoneNumber){
      return res.status(400).json({ message: 'Phone number is required' });
    }else if(phoneNumber.length < 10 || phoneNumber.length > 15){
      return res.status(400).json({ message: 'Phone number must be between 10 and 15 characters long' });
    }else if(!gender){
      return res.status(400).json({message: 'gener is required'})
    }else if(!IDs || IDs.length === 0){
      return res.status(400).json({ message: 'At least one ID is required' });
    }
    const user = await User.findById(req.user.id);
    if (!user) {
      return res.status(404).json({ message: 'User not found' });
    }
    // Update personal info
    if( fullName) user.fullName = fullName;
    if (dateOfBirth) user.dateOfBirth = dateOfBirth;
    if (phoneNumber) user.phoneNumber = phoneNumber;
    if(IDs) user.IDs = IDs;
    await user.save();
    res.json({
      message: 'User details updated successfully',
      user: {
        id: user._id,
        userId: user.userId,
        email: user.email,
        fullName: user.fullName,
        dateOfBirth: user.dateOfBirth,
        phoneNumber: user.phoneNumber,
        IDs: user.IDs,
      }
    });

  }catch (err) {
    console.error('Update personal info error:', err.message);
    res.status(400).json({ message: err.message });
  }
}
const  updateAddress = async (req, res) => {
  try {
    if (!req.body) {
      return res.status(400).json({ message: 'Request body is missing' });
    }
    const { addressType, address, floorOrApartmentNumber, contactName, phoneNUmber } = req.body;
    if(!addressType) {
      return res.status(400).json({ message: 'Address type is required' });
    }else if(!address) {
      return res.status(400).json({ message: 'Address is required' });
    }else if(!floorOrApartmentNumber) {
      return res.status(400).json({ message: 'Floor or apartment number is required' });
    }else if(!contactName) {
      return res.status(400).json({ message: 'Contact name is required' });
    }else if(!phoneNUmber) {
      return res.status(400).json({ message: 'Phone number is required' });
    }
    const user = await User.findById(req.user.id);
    if( !user) {
      return res.status(404).json({ message: 'User not found' });
    }
    if(addressType) user.address.addressType = addressType;
    if(address) user.address.address = address;
    if(floorOrApartmentNumber) user.address.floorOrApartmentNumber = floorOrApartmentNumber;
    if(contactName) user.address.contactName = contactName;
    if(phoneNUmber) user.address.phoneNumber = phoneNUmber;
    await user.save();
    res.json({
      message: 'Address updated successfully',
      user: {
        id: user._id,
        userId: user.userId,
        email: user.email,
        fullName: user.fullName,
        address: user.address
      }
    });
  } catch (err) {
    console.error('Update address error:', err.message);
    res.status(400).json({ message: err.message });
  }
}
const updateDriverLicense = async(req, res) => {
  try{
    if(!res.body){
      return res.status(400).json({ message: 'Request body is missing' });
    }
    const {typeOfDriverLicense, classLicense, licenseNumber, driverLicenseFront, driverLicenseBack } = req.body;
    if(!typeOfDriverLicense){
      return res.status(400).json({message: 'Type of driver license is required'})
    }else if(!classLicense){
      return res.status(400).json({message: 'Class is required'})
    }else if(!licenseNumber){
      return res.status(400).json({message: 'License number is required'})
    }else if(!driverLicenseFront){
      return res.status(400).json({message: 'Front view picture is required'})
    }else if(!driverLicenseBack){
      return res.status(400).json({message: 'Back view picture is required'})
    }
    const user = await User.findById(req.user.id);
    if (!user) {
      return res.status(404).json({ message: 'User not found' });
    }
    if(typeOfDriverLicense) user.license.typeOfDriverLicense = typeOfDriverLicense;
    if(classLicense) user.license.classLicense = classLicense;
    if(licenseNumber) user.license.licenseNumber = licenseNumber;
    if(driverLicenseFront) user.license.driverLicenseFront = driverLicenseFront;
    if(driverLicenseBack) user.license.driverLicenseBack = driverLicenseBack;
    user.license.approved = false; 
    await user.save();
    res.json({
      message: 'Driver license updated successfully',
      user: {
        id: user._id,
        userId: user.userId,
        email: user.email,
        fullName: user.fullName,
        license: user.license
      }
    });
  }catch(err){
    console.error('Update driver license error:', err.message);
    res.status(400).json({ message: err.message });
  }
}
module.exports = { changePassword, deleteAccount, updatePersonalInfo, updateDriverLicense, updateAddress };