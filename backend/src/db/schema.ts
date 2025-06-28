import { pgTable, text, timestamp, uuid } from "drizzle-orm/pg-core";

export const user = pgTable("users",{
    id : uuid("id").primaryKey().defaultRandom(),
    email: text("email").notNull().unique(),
    password: text("password").notNull(),
    createdAt : timestamp("created_at").defaultNow(),
    updatedAt : timestamp("updated_at").defaultNow()
})

export type User = typeof user.$inferSelect;
export type NewUser = typeof user.$inferInsert;

