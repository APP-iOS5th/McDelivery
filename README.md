# McCurrency   ![Xcode](https://img.shields.io/badge/Xcode-007ACC?style=for-the-badge&logo=Xcode&logoColor=white)<img src="https://img.shields.io/badge/15.4.0-515151?style=for-the-badge"> ![Protopie](https://img.shields.io/badge/Protopie-%23FF6661.svg?style=for-the-badge) ![Figma](https://img.shields.io/badge/figma-%23F24E1E.svg?style=for-the-badge&logo=figma&logoColor=white)

<img src="https://github.com/APP-iOS5th/McDelivery/assets/164737302/7ff9ac47-415c-4ff6-a03f-5d82a908e706" width=480 />

## :package: 프로젝트 소개
McCurrency는 세계 여러 나라에서 사용자의 구매력을 비교할 수 있는 환율 앱입니다. <br>사용자가 입력한 금액을 실시간 환율을 적용해 다양한 나라의 통화로 변환하고, 해당 금액으로 그 나라에서 몇 개의 빅맥을 구매할 수 있는지 계산합니다.

## :world_map: 주요 기능
**실시간 환율 변환** <br> 환율 API를 활용해 입력한 금액을 다양한 나라의 통화로 변환합니다.
<br><br>**빅맥 갯수를 통한 구매력 비교** <br> 변환된 금액으로 해당 국가에서 몇 개의 빅맥을 구매할 수 있는지 계산합니다.
<br><br>**다양한 나라 지원** <br> 여러 나라의 환율과 빅맥 가격 데이터를 제공합니다.
<br><br>**사용자 친화적 인터페이스** <br> 부드러운 인터랙션과 간편한 인터페이스로 직관적인 사용이 가능합니다.

## 🎞️ 실행 화면
| CurrencyView | CircularPickerView | IndexCompareView |
|---|---|---|
| gif | gif | gif |

## :people_holding_hands: 팀 McDelivery
| [임재현](https://github.com/LimJaeHyeon9298) | [이성운](https://github.com/5lsw) | [조아라](https://github.com/arachocho) | [권도율](https://github.com/YuleGlycerine) |
|---|---|---|---|
| <img src="https://avatars.githubusercontent.com/u/115773990?v=4" width=180 /> | <img src="https://avatars.githubusercontent.com/u/164517761?v=4" width=180 />| 이미지 | <img src="https://github.com/APP-iOS5th/Saver/assets/164737302/3bdf1c10-1c06-4696-8f9a-a61a4a73fe6b" width=180 /> |

## :microscope: 담당
임재현 [@LimJaeHyeon9298](https://github.com/LimJaeHyeon9298)
* 담당:
* 구현 기능:

이성운 [@5lsw](https://github.com/5lsw)
* 담당:
* 구현 기능:

조아라 [@arachocho](https://github.com/arachocho)
* 담당: 프로젝트의 전반적인 UI 개발
* 구현 기능: 프로젝트의 두 개의 주요 뷰(View)와 기본적인 UI를 구현
  - First View
    - Default 로 대한민국을 설정하여 원하는 금액을 입력, 수정 할 수 있음
    - UIButton을 이용해 원하는 국가를 선택할 수 있는 버튼을 만듦
  - Second View
    - 나라 슬롯을 추가할 수 있는 버튼을 생성함
    - 추가한 셀을 슬라이드하여 삭제할 수 있는 기능을 추가함
  


권도율 [@YuleGlycerine](https://github.com/YuleGlycerine)
* 담당: 기획, 디자인 및 인터랙션과 모션 구현, UI 디벨롭
  - 기획과 UI 디자인, 인터랙션 디자인을 하였습니다.
  - 애니메이션과 모션 전반을 구현했습니다.
  - 팀이 구현한 화면을 디자인에 가깝게 조정하였습니다.
* 구현 기능:
  - 입력 금액 애니메이션
  - 슬롯 머신 애니메이션
  - 탭바 슬라이드 마이크로 인터랙션
  - 원형 피커 뷰 마이크로 인터랙션


## 🧾 기술 스택
- Swift
- UIKit
- MVC 패턴 
- UserDefaults
- Animations
- AVKit 
- Singleton 

## :hammer_and_wrench: 문제 해결 과정
