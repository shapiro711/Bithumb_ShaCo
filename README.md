# ✨ Bithumb 프로젝트

- 프로젝트 진행자: [안진홍 (Coden)](https://github.com/ictechgy), [김도형 (Shapiro)](https://github.com/shapiro711)

&nbsp;

## 🔥 프로젝트 기간 고민한 내용

### [아래 문제들에 대한 Trouble Sooting 바로보기](https://coden.notion.site/Bithumb-Project-14bd7bab4a3742918789784a85ac1050)

1. Rest 통신의 결과 값 타입 문제
2. Ticker 업데이트 문제
3. 호가창(OrderBook) 업데이트 문제
4. Race Condition 문제
5. WebSocket 연결 유실 문제

&nbsp;

## 목차
+ [📌 프로젝트 개요](#-프로젝트-설명)   
+ [📺 실행 화면](#-실행-화면)
+ [🧑‍💻 네트워크 모델 구성](#-네트워크-모델-구성)
+ [🎨 뷰 구성](#-뷰-구성)

&nbsp;   

## 📌 프로젝트 설명

Bithumb Public API를 이용하여 Bithumb의 가상자산 데이터를 보여주는 앱

가상자산의 목록, 호가, 시세, 차트, 입출금 현황 등의 정보를 UI로 표현한다.

&nbsp;   

## 📅 프로젝트 일정

### 프로젝트 진행 기간: 2022.1.17(월) ~ 2022.2.2(수)

- 1주 차: REST API, WebSocket API를 사용하기 위한 네트워크 설계
- 2주 차: 데이터를 이용한 UI 구현

&nbsp;   

## 🔖 프로젝트 진행 방식

- 100% 페어 프로그래밍으로 진행
- Gitmoji를 이용한 커밋 ex) ✨ [Feat]: 웹소켓 통신 중에 발생할 수 있는 구독 및 클라이언트 에러 처리 구현
- GitHub Flow 브런칭 규칙 사용 ex) feature/design-network-type

|구현 내용|도구|
|:--:|:--:|
|아키텍쳐|MVC|
|UI|UIKit|
|로컬 데이터 저장소|UserDefaults|

&nbsp;   

## 📚 라이브러리
### CocoaPods을 이용하여 라이브러리 관리
 -  XLPagerTabStrip은 SafeArea를 지원하지 않는 이슈로 인해 커스텀을 하여 gitignore에서 제외
 
|이름|역할|
|:--:|:--:|
|[Charts](https://github.com/danielgindi/Charts)|차트를 그리기 위해 사용|
|[SpreadSheetView](https://github.com/bannzai/SpreadsheetView)|SpreadSheet 그리기 위해 사용|
|[XLPagerTabStrip](https://github.com/xmartlabs/XLPagerTabStrip)|화면 전환을 돕기 위해 사용|

&nbsp; 

## 📺 실행 화면

|가상자산 목록|입출금 현황|관심 목록|
|:--:|:--:|:--:|
|<img width="200" alt="코인 목록" src="https://user-images.githubusercontent.com/57553889/152048208-ad8c9169-76c6-4ad9-8bef-75d02ed5b8aa.gif">|<img width="200" alt="입출금 현황" src="https://user-images.githubusercontent.com/57553889/151996453-a4e8c8f8-f449-4e7d-b7e7-41b1f3002419.gif">|<img width="200" alt="관심 목록" src="https://user-images.githubusercontent.com/57553889/151996344-42d534e5-6186-42f2-95db-4490ed6a73e4.gif">|

&nbsp; 

|호가|차트|시세|
|:--:|:--:|:--:|
|<img width="200" alt="호가" src="https://user-images.githubusercontent.com/57553889/152024482-bc3c7ff6-99d8-44d0-ab33-5cbc94076d9e.gif">|<img width="200" alt="차트" src="https://user-images.githubusercontent.com/57553889/151996463-43222550-7979-4ce1-8559-f7fe143c8600.gif">|<img width="200" alt="시세" src="https://user-images.githubusercontent.com/57553889/151996442-0b94451b-7607-4520-8446-f6e568cad2a8.gif">|

&nbsp; 

|더보기|에러 화면|
|:--:|:--:|
|<img width="200" alt="더보기" src="https://user-images.githubusercontent.com/57553889/151996419-f315d93e-a123-47cf-962f-8f5a6421772e.gif">|<img width="200" alt="에러" src="https://user-images.githubusercontent.com/57553889/151996449-7438cd5d-96da-4ae0-8922-4ba81ddc4c31.gif">|

&nbsp;   

# 🧑‍💻 네트워크 모델 구성

<img width="700" alt="네트워크 설계" src="https://user-images.githubusercontent.com/57553889/151996946-44ecabf9-a1b9-4542-a490-ae9917ee8ec0.png">|

&nbsp;   

## 1. Repository

- RestService, WebSocketService를 소유하고 있다.
- ViewController의 Request를 받아 네트워크 통신을 실행한다.
- Request를 통해 EndPoint를 생성하여 Service에게 전달한다.
- 모델에서 사용하는 Entity를 DTO로 변환하여 네트워크 결과를 ViewController에게 전달한다.

&nbsp;   

## 2. RestService

- EndPoint를 통해 URLRequest를 생성하여 RestSessionManager에게 전달한다.

&nbsp;   

## 3. RestSessionManager

- URLSession을 통해 실제 HTTP 통신을 진행한다.

&nbsp;   

## 4. WebSocketService

- WebSocket 서버와 접속을 위해 EndPoint로 URLRequest를 생성하고 WebSocketSessionManager에게 전달한다.
- 클라이언트에서 보낼 메세지나 서버에서 받은 메세지를 처리한다.

&nbsp;   

## 5. WebSocketSessionManager

- URLSession을 통해 실제 WebSocket 통신을 진행한다.

&nbsp;   

# 🎨 뷰 구성

<img width="800" alt="네트워크 설계" src="https://user-images.githubusercontent.com/57553889/151996951-d6bb20bf-3317-4a58-8e9f-946c24916508.png">

## 1. Exchange  View

- 인기, KRW, BTC, 관심별 목록 구현
- XLPagerTabStrip을 이용한 Paging 구현
- 스와이프를 통한 화면 전환 기능 구현

&nbsp;   

## 2. 메인 화면

<img width="200" alt="코인 목록" src="https://user-images.githubusercontent.com/57553889/152048208-ad8c9169-76c6-4ad9-8bef-75d02ed5b8aa.gif">

- Bithumb 가상자산 목록 구현
- 전날 밤을 기준으로 현재가, 변동률, 거래금액을 표시
- 변동이 있는 가상자산의 이전 가격과 비교하여 애니메이션 구현
- 가상자산 목록의 셀 클릭 시 ExchangeDetail View로 이동

&nbsp;   

## 3. Exchange Detail  View

1. Header View
    - 선택한 가상자산의 현재가 표시
    - 전날 밤을 기준으로 변동 가격, 변동률 표시
2. Container View
    - 호가, 차트, 시세 화면 구현
    - XLPagerTabStrip을 이용한 Paging 구현
3. 네비게이션 아이템 ⭐️ 버튼을 통해 선택한 가상자산 즐겨찾기 목록 추가 및 삭제 구현

&nbsp;   

## 4. 호가

<img width="200" alt="호가" src="https://user-images.githubusercontent.com/57553889/152024482-bc3c7ff6-99d8-44d0-ab33-5cbc94076d9e.gif">

- 매도, 매수에 대한 호가창 구현
- 가격, 수량과 전날 밤 대비 등락률 표시

&nbsp;   

## 5. 차트

<img width="200" alt="호가" src="https://user-images.githubusercontent.com/57553889/151996463-43222550-7979-4ce1-8559-f7fe143c8600.gif">

- Segmented Control을 이용하여 1분, 10분, 30분, 1시간, 일별 차트 선택 기능 추가
- CandleStick 차트와 거래량을 표시하는 Bar 차트 구현

&nbsp;   

## 6. 시세

<img width="200" alt="시세" src="https://user-images.githubusercontent.com/57553889/151996442-0b94451b-7607-4520-8446-f6e568cad2a8.gif">

- SpreadSheetView를 이용하여 뷰 구성
- 선택한 가상자산의 체결 시간, 체결가격, 체결량을 표시
- 체결가격은 전날 밤과 비교하여 색 표시
- 체결량은 매수, 매도에 따라 색 표시

&nbsp;   

## 7. 입출금 현황

<img width="200" alt="입출금 현황" src="https://user-images.githubusercontent.com/57553889/151996453-a4e8c8f8-f449-4e7d-b7e7-41b1f3002419.gif">

- 메인 화면에서 탭바를 통해 이동
- 각각의 가상자산들 입출금 현황을 표시

&nbsp;   

## 8. 더보기

<img width="200" alt="더보기" src="https://user-images.githubusercontent.com/57553889/151996419-f315d93e-a123-47cf-962f-8f5a6421772e.gif">

- 메인 화면에서 탭바를 통해 이동
- 사용한 오픈소스와 라이선스 명시
- 프로젝트 기간 너무 고생한 팀원 소개

&nbsp;   

## 9. 에러 알림

<img width="200" alt="더보기" src="https://user-images.githubusercontent.com/57553889/151996449-7438cd5d-96da-4ae0-8922-4ba81ddc4c31.gif">


- 네트워크 연결이 되지 않았을때 사용자에게 알릴 수 있는 Alert 창을 보여줌
- 앱 사용 도중 네트워크 연결이 유실되어도 사용자에게 알릴 수 있는 Alert 창을 보여줌
- 내부적인 문제 (Parsing error, URL 문제, 등등)은 알 수 없는 에러로 사용자에게  Alert 창을 보여줌
