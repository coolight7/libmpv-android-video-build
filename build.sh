# 重新构建的话，留意 libxml2 是否构建成功
act --pull false -v -W .github/workflows/build.yaml  --job "build" --env-file .env --reuse
