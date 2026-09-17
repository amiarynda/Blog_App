import { mysqlTable, mysqlEnum, int, varchar, text, timestamp } from "drizzle-orm/mysql-core";

export const POST_STATUS = ["draft", "published"] as const;

// CATEGORIES
export const categoriesTable = mysqlTable("categories", {
  id: int("id").autoincrement().primaryKey(),
  name: varchar("name", { length: 100 }).notNull().unique(),
  createdAt: timestamp("created_at").defaultNow(),
  updatedAt: timestamp("updated_at").defaultNow().onUpdateNow(),
});

// POSTS
export const postsTable = mysqlTable("posts", {
  id: int("id").autoincrement().primaryKey(),
  categoryId: int("category_id").references(() => categoriesTable.id, { onDelete: "set null" }),
  title: varchar("title", { length: 255 }).notNull(),
  content: text("content").notNull(),
  imageUrl: text("image_url"),
  status: mysqlEnum("status", POST_STATUS).notNull().default("published"),
  createdAt: timestamp("created_at").defaultNow(),
  updatedAt: timestamp("updated_at").defaultNow().onUpdateNow(),
});

// export const USER_ROLES = [ "user", "admin" ] as const;
// export const POST_STATUS = [ "delete", "published" ] as const;

// // USERS
// export const usersTable = mysqlTable("users", {
//   id: int("id").autoincrement().primaryKey(),
//   username: varchar("username", { length: 50 }).notNull(),
//   email: varchar("email", { length: 100 }).notNull().unique(),
//   password: varchar("password", { length: 255 }).notNull(),
//   role: mysqlEnum("role", USER_ROLES).notNull().default("user"),
//   createdAt: timestamp("created_at").defaultNow(),
//   updatedAt: timestamp("updated_at").defaultNow().onUpdateNow(),
// });

// // CATEGORIES 
// export const categoriesTable = mysqlTable("categories", {
//   id: int("id").autoincrement().primaryKey(),
//   name: varchar("name", { length: 100 }).notNull().unique(), // Contoh: "Teknologi", "Kesehatan"
//   slug: varchar("slug", { length: 100 }).notNull().unique(), // Contoh: "teknologi", "kesehatan"
//   createdAt: timestamp("created_at").defaultNow(),
//   updatedAt: timestamp("updated_at").defaultNow().onUpdateNow(),
// });

// // POSTS (kolom category_id yang terhubung ke tabel categories)
// export const postsTable = mysqlTable("posts", {
//   id: int("id").autoincrement().primaryKey(),
//   userId: int("user_id").notNull().references(() => usersTable.id, { onDelete: "cascade" }),
//   // Menghubungkan post ke kategori tertentu
//   categoryId: int("category_id").notNull().references(() => categoriesTable.id, { onDelete: "restrict" }), 
//   title: varchar("title", { length: 255 }).notNull(),
//   content: text("content").notNull(),
//   imageUrl: text("image_url"), 
//   imagePublicId: varchar("image_public_id", { length: 255 }), 
//   status: mysqlEnum("status", POST_STATUS).notNull().default("published"),
//   createdAt: timestamp("created_at").defaultNow(),
//   updatedAt: timestamp("updated_at").defaultNow().onUpdateNow(),
// });

// // COMMENTS
// export const commentsTable = mysqlTable("comments", {
//   id: int("id").autoincrement().primaryKey(),
//   postId: int("post_id").notNull().references(() => postsTable.id, { onDelete: "cascade" }),
//   userId: int("user_id").notNull().references(() => usersTable.id, { onDelete: "cascade" }),
//   comment: text("comment").notNull(),
//   createdAt: timestamp("created_at").defaultNow(),
//   updatedAt: timestamp("updated_at").defaultNow().onUpdateNow(),
// });
