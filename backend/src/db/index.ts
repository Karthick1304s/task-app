import { Pool } from 'pg';
import {drizzle} from 'drizzle-orm/node-postgres'


const pool = new Pool({
    connectionString: "postgres://postgres:password@db:5432/db",
});

export const db= drizzle(pool);

