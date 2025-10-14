# 重新构建的话，留意 libxml2 是否构建成功
act -v -W .github/workflows/build.yaml --env-file .env --reuse
