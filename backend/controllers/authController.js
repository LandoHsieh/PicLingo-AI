import bcrypt from 'bcrypt';
import jwt from 'jsonwebtoken';
import { supabase } from '../config/db.js';
import { validateEmail, validatePassword } from '../utils/validator.js';

export const register = async (req, res) => {
    try {
        const { email, password, username } = req.body;

        // 驗證輸入
        if (!validateEmail(email)) {
            return res.status(400).json({ error: '無效的電子郵件格式' });
        }

        if (!validatePassword(password)) {
            return res.status(400).json({ error: '密碼必須至少8個字元，包含大小寫字母和數字' });
        }

        // 檢查email是否已存在
        const { data: existingUser } = await supabase
            .from('users')
            .select('id')
            .eq('email', email)
            .single();

        if (existingUser) {
            return res.status(400).json({ error: '此電子郵件已被註冊' });
        }

        // 加密密碼
        const salt = await bcrypt.genSalt(10);
        const hashedPassword = await bcrypt.hash(password, salt);

        // 建立新用戶
        const { data: newUser, error } = await supabase
            .from('users')
            .insert([
                {
                    email,
                    password_hash: hashedPassword,
                    username,
                    tier: 'free',
                    daily_credit_limit: 10,
                    current_credits: 10
                }
            ])
            .select()
            .single();

        if (error) {
            throw error;
        }

        // 產生 JWT
        const token = jwt.sign(
            { userId: newUser.id },
            process.env.JWT_SECRET,
            { expiresIn: '7d' }
        );

        res.status(201).json({
            message: '註冊成功',
            token,
            user: {
                id: newUser.id,
                email: newUser.email,
                username: newUser.username,
                tier: newUser.tier
            }
        });

    } catch (error) {
        res.status(500).json({ error: '註冊過程發生錯誤' });
    }
};

export const login = async (req, res) => {
    try {
        const { email, password } = req.body;

        // 查找用戶
        const { data: user, error } = await supabase
            .from('users')
            .select('*')
            .eq('email', email)
            .single();

        if (error || !user) {
            return res.status(401).json({ error: '電子郵件或密碼錯誤' });
        }

        // 驗證密碼
        const validPassword = await bcrypt.compare(password, user.password_hash);
        if (!validPassword) {
            return res.status(401).json({ error: '電子郵件或密碼錯誤' });
        }

        // 產生 JWT
        const token = jwt.sign(
            { userId: user.id },
            process.env.JWT_SECRET,
            { expiresIn: '7d' }
        );

        res.json({
            message: '登入成功',
            token,
            user: {
                id: user.id,
                email: user.email,
                username: user.username,
                tier: user.tier
            }
        });

    } catch (error) {
        res.status(500).json({ error: '登入過程發生錯誤' });
    }
};

export const getProfile = async (req, res) => {
    try {
        // 從 authenticateToken 中介層獲取用戶資訊
        const userId = req.user.id;

        // 從資料庫獲取最新的用戶資料
        const { data: user, error } = await supabase
            .from('users')
            .select(`
                id,
                email,
                username,
                tier,
                daily_credit_limit,
                current_credits,
                created_at,
                updated_at
            `)
            .eq('id', userId)
            .single();

        if (error || !user) {
            return res.status(404).json({ error: '找不到用戶資料' });
        }

        // 獲取用戶的使用統計
        const { data: usageStats, error: usageError } = await supabase
            .from('API_Usage_Log')
            .select('api_type, status')
            .eq('user_id', userId)
            .gte('request_timestamp', new Date(Date.now() - 30 * 24 * 60 * 60 * 1000).toISOString()) // 最近30天
            .order('request_timestamp', { ascending: false });

        // 計算使用統計
        const stats = {
            total_requests: usageStats?.length || 0,
            successful_requests: usageStats?.filter(log => log.status === 'success').length || 0,
            api_type_breakdown: usageStats?.reduce((acc, log) => {
                acc[log.api_type] = (acc[log.api_type] || 0) + 1;
                return acc;
            }, {}) || {}
        };

        res.json({
            user: {
                id: user.id,
                email: user.email,
                username: user.username,
                tier: user.tier,
                daily_credit_limit: user.daily_credit_limit,
                current_credits: user.current_credits,
                created_at: user.created_at,
                updated_at: user.updated_at
            },
            usage_statistics: stats,
            subscription: {
                plan: user.tier,
                credits_remaining: user.current_credits,
                daily_limit: user.daily_credit_limit
            }
        });

    } catch (error) {
        console.error('獲取用戶資料時發生錯誤:', error);
        res.status(500).json({ error: '獲取用戶資料時發生錯誤' });
    }
};

export const updateProfile = async (req, res) => {
    try {
        const userId = req.user.id;
        const { username, email, currentPassword, newPassword } = req.body;

        // 獲取當前用戶資料
        const { data: currentUser, error: fetchError } = await supabase
            .from('users')
            .select('*')
            .eq('id', userId)
            .single();

        if (fetchError) {
            return res.status(404).json({ error: '找不到用戶資料' });
        }

        // 準備更新的資料
        const updates = {};

        // 驗證並更新 email
        if (email && email !== currentUser.email) {
            if (!validateEmail(email)) {
                return res.status(400).json({ error: '無效的電子郵件格式' });
            }

            // 檢查 email 是否已被使用
            const { data: existingUser } = await supabase
                .from('users')
                .select('id')
                .eq('email', email)
                .neq('id', userId)
                .single();

            if (existingUser) {
                return res.status(400).json({ error: '此電子郵件已被其他用戶使用' });
            }

            updates.email = email;
        }

        // 更新用戶名
        if (username && username !== currentUser.username) {
            if (username.length < 2 || username.length > 30) {
                return res.status(400).json({ error: '用戶名長度必須在2到30個字元之間' });
            }
            updates.username = username;
        }

        // 如果要更改密碼
        if (currentPassword && newPassword) {
            // 驗證當前密碼
            const validPassword = await bcrypt.compare(currentPassword, currentUser.password_hash);
            if (!validPassword) {
                return res.status(401).json({ error: '當前密碼錯誤' });
            }

            // 驗證新密碼格式
            if (!validatePassword(newPassword)) {
                return res.status(400).json({ error: '新密碼必須至少8個字元，包含大小寫字母和數字' });
            }

            // 加密新密碼
            const salt = await bcrypt.genSalt(10);
            const hashedPassword = await bcrypt.hash(newPassword, salt);
            updates.password_hash = hashedPassword;
        }

        // 如果沒有任何更新
        if (Object.keys(updates).length === 0) {
            return res.status(400).json({ error: '沒有提供任何更新資料' });
        }

        // 更新用戶資料
        const { data: updatedUser, error: updateError } = await supabase
            .from('users')
            .update({
                ...updates,
                updated_at: new Date().toISOString()
            })
            .eq('id', userId)
            .select(`
                id,
                email,
                username,
                tier,
                daily_credit_limit,
                current_credits,
                created_at,
                updated_at
            `)
            .single();

        if (updateError) {
            throw updateError;
        }

        // 如果密碼被更改，產生新的 JWT
        let newToken = null;
        if (updates.password_hash) {
            newToken = jwt.sign(
                { userId: updatedUser.id },
                process.env.JWT_SECRET,
                { expiresIn: '7d' }
            );
        }

        res.json({
            message: '個人資料更新成功',
            user: {
                id: updatedUser.id,
                email: updatedUser.email,
                username: updatedUser.username,
                tier: updatedUser.tier,
                daily_credit_limit: updatedUser.daily_credit_limit,
                current_credits: updatedUser.current_credits,
                created_at: updatedUser.created_at,
                updated_at: updatedUser.updated_at
            },
            ...(newToken && { token: newToken }) // 如果密碼更改，返回新的 token
        });

    } catch (error) {
        console.error('更新用戶資料時發生錯誤:', error);
        res.status(500).json({ error: '更新用戶資料時發生錯誤' });
    }
}; 