import express from "express";
import cors from "cors";
import categoryRouter from "./routes/category.route";
import postRouter from "./routes/post.route";


const app = express();
const PORT = 5000;

app.use(express.json());
app.use(cors());
app.use("/posts", postRouter);
app.use("/categories", categoryRouter);

app.get("/", (req, res) => {
  res.send("Hello Express + TypeScript!");
});

app.listen(PORT, () => {
  console.log(`Server running on http://localhost:${PORT}`);
});
