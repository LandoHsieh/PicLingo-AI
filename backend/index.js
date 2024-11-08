import express from 'express'
import * as dotenv from 'dotenv'
import cors from 'cors'
import helmet from 'helmet'
import rateLimit from 'express-rate-limit'
import authRoutes from './routes/authRoutes.js'

const app = express()
const PORT = process.env.PORT || 3000

dotenv.config()

// 安全性中介層
app.use(helmet()) // 加入各種 HTTP 標頭以提高安全性
app.use(cors({
    origin: process.env.FRONTEND_URL || 'http://localhost:3000',
    credentials: true
}))

// 請求限制中介層
const limiter = rateLimit({
    windowMs: 15 * 60 * 1000, // 15 分鐘
    max: 100 // 每個 IP 限制 100 個請求
})
app.use(limiter)

// 請求解析中介層
app.use(express.json())
app.use(express.urlencoded({ extended: true }))

// API 路由
app.use('/api/auth', authRoutes)

// 根路由
app.get('/', (req, res) => {
    res.json({ message: "PicLingo API Server is running." })
})

// 404 處理
app.use((req, res) => {
    res.status(404).json({ error: "找不到該路徑" })
})

// 錯誤處理中介層
app.use((err, req, res, next) => {
    console.error(err.stack);
    res.status(500).json({
        error: "伺服器錯誤",
        message: process.env.NODE_ENV === 'development' ? err.message : undefined
    })
})

app.listen(PORT, () => {
    console.log(`Server is running on http://localhost:${PORT}`)
})


