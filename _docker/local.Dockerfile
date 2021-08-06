# 개발 환경, 로컬 환경에서의 Docker [도커 파일]

# slim-buster 는 데비안의 경량화 버전을 말함
FROM python:3.9.5-slim-buster
WORKDIR /app

# requirements.txt 를 먼저 복사함. 
COPY requirements.txt .

# pip 의존성 설치
RUN pip install -r requirements.txt

# 소스 코드 복사
WORKDIR /app/web