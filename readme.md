# 맞춤형 주식 포트폴리오 추천 웹서비스 구현 프로젝트

## 프로젝트 개요 
국민 1인당 1주식 계좌시대가 된 현재.  
저금리 기조가 장기간 이어지면서 원금 손실이 가능한 고위험 투자임에도 불구하고 고수익을 쫓는 직접 투자자들이 늘어나고 있다.  
이러한 사회경향을 반영하여 개인의 주식 포트폴리오 구성을 데이터 기반으로 추천해주는 프로젝트를 기획하였다.  <br><br>
본 프로젝트는 투자 금액에 맞추어 원하는 종목으로 구성된 포트폴리오를 최적화하는 알고리즘과 웹서비스를 구현한다.  
주로 고액 자산가만을 대상으로 하여 접근성이 낮았던 기존 개인 자산관리(PB) 서비스를 <b>소액의 투자금액</b>으로 <b>내가 원하는 시간과 장소</b>에서 <b>데이터 기반의 객관적인 추천</b>을 받을 수 있다는 것이 큰 장점이다.<br><br>
![image](https://user-images.githubusercontent.com/81539406/147208886-4bd5fd34-d73d-4cf6-9460-e8ace511b525.png)

## 설계의 주안점
1. 투자금액, 투자기간, 리스크(변동성) 제약, 투자 종목에 따라 <b>맞춤형</b> 포트폴리오 추천
2. 투자종목은 직접 선택할 수 있으며, <b>종목을 선택하는 5가지 전략</b>을 제시<br> 
   1) 모멘텀 1개월: 최근 1개월 수익률이 가장 높은 상위 30개 종목을 선택 (상대모멘텀)
   2) 모멘텀 3개월: 최근 3개월 수익률이 가장 높은 상위 30개 종목을 선택 (상대모멘텀)
   3) 듀얼모멘텀: 상대 모멘텀 x 절대 모멘텀
   4) 급등주: 특정 거래일의 거래량이 이전 20일의 평균 거래량보다 1,000% 이상 급증하는 종목을 선택
   5) 상승일 빈도: 최근 1년의 데이터를 기준으로, 전일 기준 상승 빈도가 높은 상위 30개 종목을 선택

3. <b>포트폴리오 최적화</b> 방법은 2가지가 있으며, 선택 가능
   1) Maximize 샤프지수
   2) 설정한 변동성 내에서 Maximize 수익률
4. 소액의 직접투자자도 부담 없이 이용 가능한 <b>개인 맞춤형 추천 서비스</b>
5. 시간과 장소 불문하고 편리하게 활용할 수 있는 <b>웹 서비스</b> 제공

## 시연영상
[Project Demo Video](https://youtu.be/MZu7zety-ec)

## 설치된 패키지
* `pip install django` : sqlparse, pytz, asgiref, django
* `pip install mysql-connector-python` : protobuf
* `pip install django-settings-export` : django-settings-export
* `pip install factory-boy` : text-unidecode, python-dateutil, Faker, factory-boy

`requirements.txt` 참고


## git 으로 코드를 내려받기
서브모듈을 포함하고 있으므로, 서브모듈에 대한 명령어도 같이 포함.

```
git clone --recursive https://github.com/AI-stock-team-project/aistock-main-web.git <폴더명>
cd <폴더명>
git submodule foreach --recursive git checkout master
```



만약, 단순히 git clone 만 했을 때에, data-api 폴더가 비어있다면 (서브모듈을 내려받지 못했다면) 다음의 명령어로 data-api 폴더 내의 파일을 내려받기
```
git submodule update --init --recursive
git submodule foreach --recursive git checkout master
```


### git pull 업데이트 내려받을 때
```
git pull && git submodule update --recursive
```

코드를 새로 받으면, 데이터베이스에 변경 같은 부분이 있을 때가 있어서, 
셋팅할 때와 마찬가지로 docker-compose down 하고 up 하는 커맨드를 해줘야 한다. 해당 커맨드는 다음 항목을 참조할 것


## 개발 환경 셋팅
docker를 이용하여 구동환경을 맞춰주고, 개발도구(PyCharm 또는 VSCode)로 작업을 진행한다.

환경 셋팅하는 순서
1. 장고 설정하기 
    1. `/config/settings/local.example.py`을 복사해서 `/config/settings/local.py`를 새로 만든다.
    2. 설정파일(`local.py`)에서 입력해줘야 할 것들
        * `SECRET_KEY`설정 : `python config/settings/generate_secretkey.py` 커맨드를 실행하면 키를 랜덤하게 생성해주는데, 생성된 키 값을 복사해서 넣어주도록 한다.
2. 도커 환경변수 설정하기
    1. `_docker` 폴더에서 `.local.env.example`을 복사해서 `.local.env`파일을 새로 만든다.
    2. 위의 설정 파일(`.local.env`)에서 다음을 입력해준다.
        - MYSQL_ROOT_PASSWORD : MYSQL의 루트계정 비밀번호 (복잡한 랜덤한 비밀번호를 넣어주면 됨)
        - MYSQL_PASSWORD : 장고에 이용할 MYSQL의 비밀번호 (복잡한 랜덤한 비밀번호를 넣어주면 됨)
        - DJANGO_SUPERUSER_USERNAME : 장고 최고관리자의 아이디
        - DJANGO_SUPERUSER_EMAIL : 장고 최고관리자의 이메일
        - DJANGO_SUPERUSER_PASSWORD : 장고 최고관리자의 비밀번호
    3. 도커 이미지 및 컨테이너를 생성하면서 실행
        ```console
        docker-compose --env-file=_docker/.local.env up --build --force-recreate -d
        ```
    4. 자동으로 실행이 된다. 접속은 http://localhost:18000
    5. 재생성을 해야하는 경우에는 3번을 하기 전에 다음의 명령어를 한 후에 한다.
        (db 볼륨 삭제)
        ```console
        docker-compose --env-file=_docker/.local.env down -v
        ```
        (컨테이너 및 이미지, 볼륨 재생성)
        ```console
        docker-compose --env-file=_docker/.local.env up --build --force-recreate -d
        ```


알아둘 사항
* 도커에서 DB를 볼륨으로 생성하였기 때문에, 이후에 다시 생성하여도 변경값이 적용되지 않을 수 있음. 이 경우 해당 볼륨을 삭제 후 진행을 하면 됨.
* 윈도우의 도커에서 Compose의 중지,재시작,삭제 등이 안 될 수 있는데, 각각의 컨테이너를 중지,재시작을 하면 동작이 됨.


## 구성
### 폴더 구성
기본 구성
* config : 설정
* templates : front-end (view) 
* static : css, js, images 등

추가된 구성
* stock : 주가 종목 정보
