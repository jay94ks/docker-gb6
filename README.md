## 그누보드6 `uvicorn` 컨테이너
이 리포지터리에 적용된 라이선스는 `MIT`입니다.
이것이 `그누보드6`의 라이선스가 `MIT`라는 것이 아닙니다.
`그누보드6`의 라이선스는 `https://github.com/gnuboard/g6/blob/master/LICENSE` 여기를 참고해 주세요.

### 사용법
본 컨테이너는 그누보드6를 지원합니다.

1. 그누보드 다운로드: https://sir.kr/main/g6/ (공식 웹사이트)
2. 다운로드 받으신 후 압축 풀어서 컨테이너 `/app/volume` 경로에 볼륨으로 마운트시켜 줍니다.
3. `src` 경로에서 작업을 합니다.

```
version: '3.4'
services:
  web:
    build:
      context: .
      dockerfile: Dockerfile
    depends_on:
      - web-db
    container_name: 'web'
    volumes:
      - "./src:/app/volume"
    ports: 
        - 80:8000 # 기본 포트가 아닌 다른 포트로 사용하시려면 포트 번호를 변경해 주세요.
        #- 22:22001#  <--SSH 접근이 필요하면 사용하세요.
    links: 
        - 'web-db'
        
  web-db:
    image: 'mysql:latest'
    container_name: 'web-db' # 설치하실때 호스트 명에 web-db를 그대로 입력하셔도 됩니다.
    restart: always
    environment:
      MYSQL_DATABASE: 'gb6'
      MYSQL_USER: 'gb6'
      MYSQL_PASSWORD: 'abcd1!'
      MYSQL_ROOT_PASSWORD: 'abcd1!' # DB 루트 계정이 필요하지 않다면 지정하지 마세요.
    volumes:
      - './db:/var/lib/mysql'
    ports: # DB에 직접 접근해서 볼 수 있어야 하는게 아니라면 지정하지 마세요.
      - '3306:3306'
    command:
      - '--character-set-server=utf8mb4'
      - '--collation-server=utf8mb4_unicode_ci'
```

### 설치될 기반 브랜치 변경하기
`Dockerfile`을 편집기로 열어 다음 줄을 찾습니다.

```
RUN git clone https://github.com/gnuboard/g6.git && mkdir -pv /app/volume && \
    cd /app/g6 && pip3 install -r requirements.txt --break-system-packages
```

해당줄 아래에 아래 명령어를 써넣습니다.
```
RUN cd /app/g6 && git checkout alembic
```
`alembic`은 원하는 버전 브랜치로 바꿔 기입하시면 됩니다.
(현재는 별다른 브랜치가 없으나, 미래에 그누보드6 개발팀이 생성한 경우 사용 가능)

### 이미 설치된 버전 변경하기
이 경우엔 `ssh`를 이용, 컨테이너에 접근하시거나, 컨테이너 외부 환경에서 변경하실 수 있습니다.

```
cd ./src
git checkout alembic
```

윈도우 환경에서 `git`을 설치하기 싫다면 (다른 `git` 기반 프로그램과 충돌 등이 염려되어...), `docker-compose.yml` 파일에서 다음 줄을 찾습니다.

```
 #- 22:22001#  <--SSH 접근이 필요하면 사용하세요.
```

이 줄의 주석을 제거합니다. `22`번 포트를 이미 사용하고 계신다면,
다른 값으로 변경하여도 무방합니다.

SSH 접근시 계정 명은 `root`, 패스워드는 `g6env`입니다.
