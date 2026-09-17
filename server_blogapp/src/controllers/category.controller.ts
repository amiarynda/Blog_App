import { Request, Response } from "express";
import { db } from "../config/db";
import { categoriesTable } from "../config/schema";

// GET /categories - Mengambil semua daftar kategori untuk dropdown aplikasi mobile
export const getCategories = async (req: Request, res: Response) => {
  try {
    // Mengambil semua data dari tabel kategori
    const data = await db.select().from(categoriesTable);
    
    return res.status(200).json({ 
      success: true, 
      data 
    });
  } catch (err) {
    return res.status(500).json({ 
      success: false, 
      message: "Gagal mengambil data kategori" 
    });
  }
};

// POST /categories - Menambahkan kategori baru
export const createCategory = async (req: Request, res: Response) => {
  try {
    const { name } = req.body;

    // Validasi input
    if (!name || name.trim() === "") {
      return res.status(400).json({
        success: false,
        message: "Nama kategori wajib diisi",
      });
    }

    // Insert data ke database
    const newCategory = await db.insert(categoriesTable).values({
      name,

    });

    return res.status(201).json({
      success: true,
      message: "Kategori berhasil ditambahkan",
      data: newCategory,
    });
  } catch (err) {
    return res.status(500).json({
      success: false,
      message: "Gagal menambahkan kategori",
      error: err instanceof Error ? err.message : err,
    });
  }
};