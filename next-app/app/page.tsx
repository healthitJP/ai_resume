"use client";
import React, { useState } from "react";

type Message = {
  id: number;
  content: string;
  sender: "user" | "bot";
};

export default function Home() {
  const [message, setMessage] = useState("");
  const [loading, setLoading] = useState(false);
  const [messages, setMessages] = useState<Message[]>([]);

  const sendMessage = async (e: React.FormEvent<HTMLFormElement>) => {
    e.preventDefault();
    if (!message.trim()) return;

    // ユーザーメッセージを追加
    const userMessage: Message = {
      id: Date.now(),
      content: message,
      sender: "user",
    };
    setMessages(prev => [...prev, userMessage]);
    setMessage("");
    setLoading(true);

    try {
      const response = await fetch("/api/chat", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ message }),
      });
      const data = await response.json();
      
      // ボットの返信を追加
      const botMessage: Message = {
        id: Date.now() + 1,
        content: data.reply,
        sender: "bot",
      };
      setMessages(prev => [...prev, botMessage]);
    } catch (error) {
      const errorMessage: Message = {
        id: Date.now() + 1,
        content: "エラーが発生しました",
        sender: "bot",
      };
      setMessages(prev => [...prev, errorMessage]);
    } finally {
      setLoading(false);
    }
  };

  return (
    <>
    <div className="min-h-screen p-8 bg-gray-50">
      <main className="max-w-2xl mx-auto flex flex-col h-[90vh]">
        {/* チャット履歴 */}
        <div className="flex-1 overflow-y-auto mb-4 space-y-4">
          {messages.map((msg) => (
            <div
              key={msg.id}
              className={`flex ${
                msg.sender === "user" ? "justify-end" : "justify-start"
              }`}
            >
              <div
                className={`max-w-[70%] p-3 rounded-lg ${
                  msg.sender === "user"
                    ? "bg-blue-500 text-white rounded-br-none"
                    : "bg-white text-gray-800 rounded-bl-none shadow"
                }`}
              >
                {msg.content}
              </div>
            </div>
          ))}
        </div>

        {/* 入力フォーム */}
        <form onSubmit={sendMessage} className="flex gap-2">
          <input
            type="text"
            className="flex-1 p-2 rounded-full border border-gray-300 focus:outline-none focus:border-blue-500"
            value={message}
            onChange={(e) => setMessage(e.target.value)}
            placeholder="メッセージを入力..."
            disabled={loading}
          />
          <button
            type="submit"
            disabled={loading}
            className="bg-blue-500 hover:bg-blue-600 text-white px-6 py-2 rounded-full disabled:opacity-50"
          >
            {loading ? "送信中..." : "送信"}
          </button>
        </form>
      </main>
    </div>
    </>
  );
}
