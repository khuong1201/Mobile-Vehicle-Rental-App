const express = require('express');
const router = express.Router();
const userLicenseController = require('../../controllers/user/license_controller');
const uploadUserLicense = require('../../middlewares/multer/upload_user_license');

router.get('/get-license', userLicenseController.getDriverLicenses);

router.post('/create-license', uploadUserLicense, userLicenseController.createDriverLicense);

router.put('/update-license', uploadUserLicense, userLicenseController.updateDriverLicense);

router.delete('/delete-license', userLicenseController.deleteDriverLicense);


module.exports = router;