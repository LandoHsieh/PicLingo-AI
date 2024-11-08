import express from 'express';
import { register, login, getProfile, updateProfile } from '../controllers/authController.js';
import { authenticateToken } from '../middleware/authMiddleware.js';

const router = express.Router();

// 公開路由
router.post('/register', register);
router.post('/login', login);
// router.post('/reset-password', resetPassword);

// 需要驗證的路由
router.get('/profile', authenticateToken, getProfile);
router.put('/update', authenticateToken, updateProfile);

export default router; 