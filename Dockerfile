# ============================================
# STAGE 1: BUILD STAGE
# ============================================
FROM node:14-alpine AS builder

WORKDIR /app

COPY package.json ./

RUN npm install --legacy-peer-deps

COPY . .

RUN CI=false npm run build


# ============================================
# STAGE 2: PRODUCTION STAGE (Nginx)
# ============================================
FROM nginx:stable-alpine AS production

COPY --from=builder /app/build /usr/share/nginx/html
RUN rm /etc/nginx/conf.d/default.conf
COPY nginx.conf /etc/nginx/conf.d/app.conf

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
