import { Router } from 'express';
import UserController from '../controllers/user_controller.js';
import  authenticateJWT  from '../middlewares/auth_middlerware.js';
import { authorizeRoles } from '../middlewares/role_middlerware.js';
import asyncHandler from '../middlewares/async_handler.js';
import UserService from '../services/user_service.js';
import getRepositories from '../repositories/index.js';
import UserValidator from '../validators/user_validate.js';

const router = Router();
const { UserRepository } = await getRepositories();
const userValidator = new UserValidator();
const service = new UserService(UserRepository, userValidator);
const controller = new UserController(service);

router.patch(
  '/password',
  authenticateJWT,
  asyncHandler(controller.updatePassword)
);

router.get(
  '/orther-profile',
  authenticateJWT,
  asyncHandler(controller.getOrtherProfile)
)

router.get(
  '/me',
  authenticateJWT,
  asyncHandler(controller.getProfile)
);
router.patch(
  '/profile',
  authenticateJWT,
  asyncHandler(controller.updateProfile)
);

router.patch(
  '/:userId/role',
  authenticateJWT,
  authorizeRoles('admin', 'owner', 'renter'),
  asyncHandler(controller.updateRole)
);

router.post(
  '/:userId/license',
  authenticateJWT,
  authorizeRoles('renter', 'owner'),
  asyncHandler(controller.addLicense)
);

router.patch(
  '/:userId/license/:licenseId',
  authenticateJWT,
  authorizeRoles('renter', 'owner'),
  asyncHandler(controller.updateLicense)
);

router.delete(
  '/:userId/license/:licenseId',
  authenticateJWT,
  authorizeRoles('renter', 'owner'),
  asyncHandler(controller.deletedLicense)
);

router.post(
  '/:userId/address',
  authenticateJWT,
  authorizeRoles('renter', 'owner'),
  asyncHandler(controller.addAddress)
);

router.patch(
  '/:userId/address/:addressId',
  authenticateJWT,
  authorizeRoles('renter', 'owner'),
  asyncHandler(controller.updateAddress)
);

router.delete(
  '/:userId/address/:addressId',
  authenticateJWT,
  authorizeRoles('renter', 'owner'),
  asyncHandler(controller.deleteAddress)
);

export default router;
