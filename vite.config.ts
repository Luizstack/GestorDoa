import { defineConfig } from "vite-plus";

export default defineConfig({
  server: {
    port: 5173,
    // Encaminha as chamadas /api para a API Express (porta 3000)
    proxy: {
      "/api": "http://localhost:3000",
    },
  },
  fmt: {},
  lint: {
    jsPlugins: [{ name: "vite-plus", specifier: "vite-plus/oxlint-plugin" }],
    rules: { "vite-plus/prefer-vite-plus-imports": "error" },
    options: { typeAware: true, typeCheck: true },
  },
});
