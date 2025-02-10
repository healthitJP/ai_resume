import { NextResponse } from "next/server";
import { createVertex } from "@ai-sdk/google-vertex";
import { generateText } from "ai";
if (!process.env.GOOGLE_APPLICATION_CREDENTIALS) {
  throw new Error('GOOGLE_APPLICATION_CREDENTIALS environment variable is not set');
}
const credentials = JSON.parse(Buffer.from(process.env.GOOGLE_APPLICATION_CREDENTIALS, 'base64').toString('utf-8'));
export async function POST(request: Request) {
  const { message } = await request.json();
  const vertex = createVertex({
    project: process.env.GOOGLE_VERTEX_PROJECT,
    location: process.env.GOOGLE_VERTEX_LOCATION,
    googleAuthOptions: {
      credentials: credentials,
    },
  });
  const { text } = await generateText({
    model: vertex('gemini-2.0-flash-001'),
    prompt: message,
  });
  console.log(text);
  return NextResponse.json({ reply: text });
}