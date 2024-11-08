import jwt from 'jsonwebtoken';
import { supabase } from '../config/db.js';

export const authenticateToken = async (req, res, next) => {
    try {
        const authHeader = req.headers['authorization'];
        const token = authHeader && authHeader.split(' ')[1];

        if (!token) {
            return res.status(401).json({ error: '未提供認證令牌' });
        }

        const decoded = jwt.verify(token, process.env.JWT_SECRET);

        // 從 supabase 確認用戶是否存在
        const { data: user, error } = await supabase
            .from('users')
            .select('id, email, username, tier, daily_credit_limit, current_credits')
            .eq('id', decoded.userId)
            .single();

        if (error || !user) {
            return res.status(401).json({ error: '無效的認證令牌' });
        }

        req.user = user;
        next();
    } catch (error) {
        return res.status(403).json({ error: '認證令牌已過期或無效' });
    }
}; 