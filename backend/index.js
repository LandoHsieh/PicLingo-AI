import express from 'express'
import * as dotenv from 'dotenv'

const app = express()
const PORT = process.env.PORT || 3000

dotenv.config()

app.use(express.json())
app.use(express.urlencoded({extended: true}))

app.get('/', (req, res) => {
    res.json({message: "Server is running."})
})

app.use((err, req, res, next) => {
    console.error(err.stack);
    res.status(500).json({ message: "Server error"})
})

app.listen(PORT, () => {
    console.log(`Server is running on http://localhost:${PORT}`)
})


