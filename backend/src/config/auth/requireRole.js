function authorizeRoles(...allowedRoles) {
  return (req, res, next) => {
    if (!req.user) return res.status(401).json({ error: 'Unauthorized' });
    const userRole = req.user.role;
    const isAllowed = allowedRoles.includes(userRole)
      || (userRole === 'admin' && allowedRoles.includes('manager'));
    if (!isAllowed) return res.status(403).json({ error: 'Forbidden' });
    next();
  };
}

module.exports = { authorizeRoles };
