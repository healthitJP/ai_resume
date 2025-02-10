import { NextResponse } from "next/server";
import { vertex } from "@ai-sdk/google-vertex";
import { generateText } from "ai";

export async function POST(request: Request) {
  const { message } = await request.json();
  const { text } = await generateText({
    model: vertex('gemini-2.0-flash-001'),
    prompt: message,
  });
  console.log(text);
  return NextResponse.json({ reply: text });
}