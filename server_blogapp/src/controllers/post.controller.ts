import { Request, Response } from "express";
import { eq } from "drizzle-orm";
import { db } from "../config/db";
import { postsTable, categoriesTable } from "../config/schema";

export const getPosts = async (req: Request, res: Response) => {

  try {
    const data = await db.select().from(postsTable);

    return res.status(200).json({
      success: true,
      data,
    });
  } catch (err) {
    console.error("ERROR GET POSTS:", err);
    return res.status(500).json({
      success: false,
      message: "Gagal mengambil data artikel",
      error: err instanceof Error ? err.message : String(err),
    });
  }
};

// GET /posts/:id - detail artikel
export const getPostById = async (req: Request, res: Response) => {
  try {
    const id = Number(req.params.id);
    const data = await db.select().from(postsTable).where(eq(postsTable.id, id));

    if (data.length === 0) {
      return res.status(404).json({ success: false, message: "Artikel tidak ditemukan" });
    }
    return res.status(200).json({ success: true, data: data[0] });
  } catch (err) {
    console.error(err);
    return res.status(500).json({ success: false, message: "Gagal mengambil data artikel" });
  }
};

// POST /posts - buat artikel baru
export const createPost = async (req: Request, res: Response) => {
  try {
    const { title, content, categoryId, imageUrl, status } = req.body;

    // Validasi field wajib
    if (!title || !content || !categoryId) {
      return res.status(400).json({
        success: false,
        message: "title, content, categoryId, wajib diisi",
      });
    }

    // Pastikan categoryId yang dikirim beneran ada
    const categoryExists = await db
      .select()
      .from(categoriesTable)
      .where(eq(categoriesTable.id, Number(categoryId)));

    if (categoryExists.length === 0) {
      return res.status(400).json({ success: false, message: "categoryId tidak valid" });
    }

    await db.insert(postsTable).values({
      title,
      content,
      categoryId: Number(categoryId),
      imageUrl: imageUrl ?? null,
      status: status || "published",
    });

    return res.status(201).json({ success: true, message: "Artikel berhasil dibuat" });
  } catch (err) {
    console.error(err);
    return res.status(500).json({ success: false, message: "Gagal membuat artikel" });
  }
};

// PUT /posts/:id - edit artikel
export const updatePost = async (req: Request, res: Response) => {
  try {
    const id = Number(req.params.id);
    const { title, content, categoryId, imageUrl, status} = req.body;

    if (!title || !content || !categoryId) {
      return res.status(400).json({
        success: false,
        message: "title, content, dan categoryId wajib diisi",
      });
    }

    const existing = await db.select().from(postsTable).where(eq(postsTable.id, id));
    if (existing.length === 0) {
      return res.status(404).json({ success: false, message: "Artikel tidak ditemukan" });
    }

    const categoryExists = await db
      .select()
      .from(categoriesTable)
      .where(eq(categoriesTable.id, Number(categoryId)));

    if (categoryExists.length === 0) {
      return res.status(400).json({ success: false, message: "categoryId tidak valid" });
    }

await db
  .update(postsTable)
  .set({
    title,
    content,
    categoryId: Number(categoryId),
    imageUrl: imageUrl ?? null,
    status: status || "published",
  })
  .where(eq(postsTable.id, id));

const updated = await db
  .select()
  .from(postsTable)
  .where(eq(postsTable.id, id));

return res.status(200).json({
  success: true,
  message: "Artikel berhasil diperbarui",
  data: updated[0],
});
  } catch (err) {
    console.error(err);
    return res.status(500).json({ success: false, message: "Gagal memperbarui artikel" });
  }
};

// PATCH /posts/:id - update imageUrl artikel

export const updatePostImage = async (req: Request, res: Response) => {
  try {
    const id = Number(req.params.id);
    const { imageUrl } = req.body;

    if (!imageUrl) {
      return res.status(400).json({
        success: false,
        message: "imageUrl wajib diisi",
      });
    }

    const existing = await db
      .select()
      .from(postsTable)
      .where(eq(postsTable.id, id));

    if (existing.length === 0) {
      return res.status(404).json({
        success: false,
        message: "Artikel tidak ditemukan",
      });
    }

    await db
      .update(postsTable)
      .set({
        imageUrl,
      })
      .where(eq(postsTable.id, id));

    return res.status(200).json({
      success: true,
      message: "Image URL berhasil diperbarui",
    });
  } catch (err) {
    console.error(err);

    return res.status(500).json({
      success: false,
      message: "Gagal memperbarui image URL",
    });
  }
};


// DELETE /posts/:id - hapus artikel
export const deletePost = async (req: Request, res: Response) => {
  try {
    const id = Number(req.params.id);
    const existing = await db.select().from(postsTable).where(eq(postsTable.id, id));

    if (existing.length === 0) {
      return res.status(404).json({ success: false, message: "Artikel tidak ditemukan" });
    }

    await db.delete(postsTable).where(eq(postsTable.id, id));

    return res.status(204).send();
  } catch (err) {
    console.error(err);
    return res.status(500).json({ success: false, message: "Gagal menghapus artikel" });
  }
};