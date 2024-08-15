import { config } from "dotenv";
config();

export const database = {
  connectionLimit: 10,
  host: process.env.DATABASE_HOST || "localhost",
  user: process.env.DATABASE_USER || "linkster",
  password: process.env.DATABASE_PASSWORD || "linkster", // pw is hardcoded. Bad!
  database: process.env.DATABASE_NAME || "linkster",
  port: process.env.DATABASE_PORT || 3306,
};

export const port = process.env.PORT || 8080;

export const SECRET = process.env.SECRET || 'some secret key';