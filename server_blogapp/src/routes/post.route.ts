import { Router } from "express";
import {
  getPosts,
  getPostById,
  createPost,
  updatePost,
  updatePostImage,
  deletePost,
} from "../controllers/post.controller";

const router = Router();

// GET semua artikel
router.get("/", getPosts);

// GET artikel berdasarkan ID
router.get("/:id", getPostById);

// POST membuat artikel baru
router.post("/", createPost);

// PUT mengedit artikel
router.put("/:id", updatePost);

// DELETE menghapus artikel
router.delete("/:id", deletePost);

export default router;