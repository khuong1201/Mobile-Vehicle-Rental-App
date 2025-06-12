const AdminOrOwnerMiddleware = (req, res, next) => {
    const role = req.user?.role;
  
    if (role === 'admin' || role === 'owner') {
      return next();
    }
  
    return res.status(403).json({ message: 'Access denied. Admin or Owner only.' });
  };
  
  module.exports = AdminOrOwnerMiddleware;
  