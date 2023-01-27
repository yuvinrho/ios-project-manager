# 프로젝트 매니저

## 📖 목차

1. [소개](#-소개)
2. [프로젝트 구조](#-프로젝트-구조)
3. [구현 내용](#-구현-내용)
4. [타임라인](#-타임라인)
5. [실행 화면](#-실행-화면)
6. [트러블 슈팅 & 고민했던 점](#-트러블-슈팅--고민했던-점)
7. [참고 링크](#-참고-링크)

## 💻 개발환경

[![swift](https://img.shields.io/badge/swift-5.7-orange)]() [![iOS](https://img.shields.io/badge/iOS-16.2-blue)]() 

## 기술스택
|Framework|Architecture|Asynchronous|Network|LocalDB|RemoteDB|Dependency Manager|
|:---:|:---:|:---:|:---:|:---:|:---:|:---:|
|<img src="https://img.shields.io/badge/UIkit-2396F3?style=flat-square&logo=Uikit&logoColor=white"/></a> | <img src="https://img.shields.io/badge/MVC-792EE5?style=flat-square&logo=&logoColor=white"/></a> | <img src="https://img.shields.io/badge/GCD/Operation-A5CD39?style=flat-square&logo=&logoColor=white"/></a> | <img src="https://img.shields.io/badge/URLSession-EE6123?style=flat-square&logo=&logoColor=white"/></a> |<img src="https://img.shields.io/badge/CoreData-41454A?style=flat-square&logo=Apple&logoColor=white"/></a>|<img src="https://img.shields.io/badge/Firebase-FFCA28?style=flat-square&logo=FireBase&logoColor=white"/></a> | <img src="https://img.shields.io/badge/CocoaPods-EE3322?style=flat-square&logo=CocoaPods&logoColor=white"/></a>|

---
						

## 😁 소개

[로빈](https://github.com/yuvinrho)의 프로젝트 To-Do 관리 앱 입니다.


## 🛠 프로젝트 구조

## 📊 UML
추후 작성 예정


## 🌲 Tree
```
├── Controllers
│   ├── ProjectListViewController.swift
│   ├── ProjectTableViewController.swift
│   └── ProjectViewController.swift
├── Extensions
│   ├── Date.swift
│   └── UITableViewCell+Reusable.swift
├── Managers
│   └── ProjectManager.swift
├── Models
│   ├── DummyProjects.swift
│   ├── Project.swift
│   └── ProjectStatus.swift
├── Protocols
│   ├── ProjectDelegate.swift
│   └── Reusable.swift
└── Views
    ├── ProjectTableView
    │   ├── ProjectTableView.swift
    │   ├── ProjectTableViewCell.swift
    │   └── ProjectTableViewHeaderView.swift
    └── ProjectView.swift


```

## 📌 구현 내용
## ProjectTableViewController

### 프로젝트 상태 변경에 따른 셀 이동
- 프로젝트 셀을 길게 누르면 다른 상태의 테이블뷰로 이동할 수 있도록하는  팝오버 버튼이 나옵니다.
- 팝오버를 띄우기 위해 제스처를 아래와 같이 테이블 뷰에 등록해주었습니다
```swift
private func configureLongPressGesture() {
    let longPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(longPress))
    tableView.addGestureRecognizer(longPressGestureRecognizer)
}
```
- UIAlertController를 이용해 다른 프로젝트 상태의 테이블뷰로 이동하는 버튼을 갖는 알람을 구현하였습니다.
- PopoverController를 이용해 셀을 길게 누르면 만들어준 알람이 표시되어서 서로 다른 테이블 뷰 컨트롤러로 이동하도록 구현하였습니다.

![](https://i.imgur.com/UpbraHA.gif)

### 셀 스와이프 시 삭제
- 셀을 오른쪽에서 왼쪽방향 으로 스와이프하면 셀을 삭제하도록 구현하였습니다.
```swift
//MARK: Cell Swipe Delete Action
func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
    let targetProject = fetchProject(tableView: tableView, indexPath: indexPath)
    let deleteAction = UIContextualAction(style: .destructive, title: nil) { (_, _, success) in
        self.deleteProjectCell(tableView: tableView, project: targetProject)
        success(true)
    }
    deleteAction.title = "삭제"
    return UISwipeActionsConfiguration(actions: [deleteAction])
}

```

![](https://i.imgur.com/rfc8QWP.gif)

---
## ProjectViewController
### 프로젝트 추가 및 수정
- `ProjectViewController`가 프로젝트 추가를 위한건지, 프로젝트 수정을 위한 건지 구분하기 위해 `ProjectViewController` 내부에 아래와 같이 ViewMode 열거형을 정의해주었습니다.

```swift
final class ProjectViewController: UIViewController {
    enum ViewMode {
        case add
        case edit
    }
    
    private var mode: ViewMode
    ...
}
```

- `mode` 값에 따라 네비게이션 바를 생성하도록 하였습니다.
```swift
private func makeRightBarButton() -> UIBarButtonItem {
    let rightButtonAction = UIAction { [weak self] _ in
        self?.touchUpRightBarButton()
    }
    switch mode {
    case .add:
        return UIBarButtonItem(systemItem: .done, primaryAction: rightButtonAction)
    case .edit:
        return UIBarButtonItem(systemItem: .edit, primaryAction: rightButtonAction)
    }
}
```

![](https://i.imgur.com/D7QnyOJ.gif)

### Description 작성시 글자제한
- 프로젝트 요구 사항에 따라 텍스트가 1000자가 넘지 않도록 구현하였습니다.
```swift
extension ProjectViewController: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let currentText = textView.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
        let changedText = currentText.replacingCharacters(in: stringRange, with: text)

        return changedText.count <= 1000
    }
}

```

### 리턴키를 누르면 키보드 내리기
- Title 작성 후 리턴키를 누르면 키보드가 내려가도록 구현하였습니다.

```swift
extension ProjectViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
```

### 키보드가 컨텐츠를 가리지 않도록 설정
- Description 작성시 키보드가 내용을 가리지 않도록 설정해주었습니다.
- iOS 15 버전 이상에서는 `keyboardLayoutGuide` 사용하고
- iOS 15 미만은 NotificationCenter 사용하여 구현하였습니다.



## ⏰ 타임라인

<details>
<summary> Step1 타임라인</summary>
<div markdown="1">       

- 프로젝트 구조 및 기술스택 정하기
    
</div>
</details>

<details>
<summary> Step2 타임라인</summary>
<div markdown="2">       
   
- **2023.01.17**
    - Project 모델 및 ProjectManager 정의
    - ProjectTableView 구현
    - ProjectListViewController 데이터 소스 설정
    
- **2023.01.18**
    - 셀 long press 제스쳐 설정 및 Popover로 셀 이동하도록 구현
    - ProjectViewController 구현
    - 뷰 디자인적 요소 수정
    
- **2023.01.19**
    - Date 타입 익스텐션 구현

- **2023.01.20**
    - ProjectTableViewCell 리팩토링

- **2023.01.23**
    - ProjectManager 리팩토링
    - 코드 컨벤션 및 접근제어자 수정

- **2023.01.24**
    - 자식 뷰컨트롤러에서 부모 뷰컨트롤러로 데이터 전달을 위한 딜리게이트 정의
    - 기존 ProjectTableView를 뷰컨트롤러로 리팩토링
    - 전체적으로 뷰 컨트롤러 리팩토링

- **2023.01.25**
    - 중복기능하는 딜리게이트 ProjectDelegate로 통합
    
</div>
</details>

<details>
<summary> Step3 타임라인</summary>
<div markdown="3">       
   
- **2023.01.26**
    - FirebaseDatabase 설치
    
</div>
</details>

## 📱 실행 화면
추후 작성 에정

## ❓ 트러블 슈팅 & 고민했던 점

### 1. ProjectListViewController 역할이 비대해지는 문제
- 기존에는 `ProjectListViewController`가 `todoListTableView`, `doingListTableView`, `doneListTableView`를 다 갖고 있어서, 테이블 뷰를 화면을 업데이트할 뿐만 아니라 데이터까지 다 관리했습니다. 이러다 보니 ProjectListViewController의 역할이 비대해지는 문제가 있었습니다.
- 각 TableView를 TableViewController로 구현해서 각 ProjectStatus(todo, doing, done)에 맞는 데이터를 관리하고 보여주도록 구현하였습니다. 
```swift
final class ProjectTableViewController: UITableViewController {
    typealias DataSource = UITableViewDiffableDataSource<Int, Project>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Int, Project>
    
    // MARK: Properties
    let status: ProjectStatus
    private var projectList: [Project] = [] {
        didSet {
            configureSnapshot(items: self.projectList)
        }
    }

    private weak var delegate: ProjectDelegate?
    private lazy var dataSource = makeDataSource()

    ...
```
- `ProjectListViewController는` 컨테이너 뷰 컨트롤러가 되어서 아래와 같이 `ProjectTableViewController`를 자식뷰로 갖도록 설정하였습니다.
```swift
private func addChildViewControllers() {
    [todoViewController, doingViewController, doneViewController].forEach {
        addChild($0)
    }
}
```
- 이렇게해서 `Project` 데이터가 변화하면 각 테이블뷰컨테이너를 업데이트 하는 역할만 하도록 구현하여, `ProjectListViewController가` 비대해지는 문제를 해결하였습니다. 
```swift
private var todoList: [Project] = [] {
    didSet {
        todoViewController.update(with: todoList)
    }
}

private var doingList: [Project] = [] {
    didSet {
        doingViewController.update(with: doingList)
    }
}

private var doneList: [Project] = [] {
    didSet {
        doneViewController.update(with: doneList)
    }
}
```


---

## 📖 참고 링크
추후 작성 예정

---
