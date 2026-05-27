# Agent Guide for This Blog

이 저장소에서 글을 추가/수정하는 에이전트는 아래 규칙을 따른다. 예시는 `d0e89a7` (`Add new post: protocol handler`) 커밋을 기준으로 정리했다.

## 프로젝트 개요

- Hugo 기반 블로그
- 테마: `DoIt` (`hugo.toml`의 `theme = "DoIt"`)
- 글 위치: `content/posts/`
- 이미지 위치: `assets/images/`
- 로컬 미리보기: `hugo serve`

## 새 글 작성법

새 글은 Markdown 파일로 `content/posts/` 아래에 만든다.

예:

```text
content/posts/protocol-handler-tests.md
```

Front matter는 TOML 형식의 `+++` 블록을 사용한다.

```toml
+++
title = 'Protocol Handler Tests: Transport-Independent by Design'
date = 2026-05-26
authors = ['Sungsik']
categories = ['C++']
tags = ['GMock', 'Testability', 'Network']
featuredImage = 'images/protocol-handler-transport-independent.png'
+++
```

권장 필드:

- `title`: 글 제목
- `date`: `YYYY-MM-DD`
- `authors`: 보통 `['Sungsik']`
- `categories`: 예: `['C++']`, `['Deep Learning']`
- `tags`: 글 주제별 태그 배열
- `featuredImage`: 대표 이미지가 있을 때만 사용

본문은 front matter 뒤에 일반 Markdown으로 작성한다.

## 이미지 추가 위치

글에 사용할 이미지는 `assets/images/` 아래에 둔다.

예:

```text
assets/images/protocol-handler-transport-independent.png
```

대표 이미지는 front matter에서 `assets/`를 제외하고 지정한다.

```toml
featuredImage = 'images/protocol-handler-transport-independent.png'
```

본문에서 이미지를 직접 참조할 때도 `/images/...` 또는 테마가 요구하는 `images/...` 경로를 사용한다.

```markdown
![Protocol handler diagram](/images/protocol-handler-transport-independent.png)
```

## 이미지 형식 주의

- SVG는 사용하지 않는다. 이 블로그/테마 설정에서는 SVG 이미지가 지원되지 않는 것으로 간주한다.
- 다이어그램이나 벡터 이미지는 PNG로 변환해서 올린다.
- 권장 형식: `png`, `jpg/jpeg`, `webp`
- favicon, manifest 등 사이트 고정 정적 파일이 아닌 글 이미지는 `static/`이 아니라 `assets/images/`에 둔다.

## 파일명 규칙

- 글 파일명: 소문자 kebab-case 권장
  - 예: `protocol-handler-tests.md`
- 이미지 파일명: 소문자 kebab-case 권장, 확장자 포함
  - 예: `protocol-handler-transport-independent.png`
- 공백, 한글 파일명, 특수문자는 피한다.

## Obsidian 글감 기반 작성 Workflow

사용자가 `~/Documents/Obsidian` 아래의 글감을 인용하거나 참고해서 블로그 글을 써 달라고 하면 다음 순서로 작업한다.

1. 원본 Obsidian 문서를 읽고 핵심 아이디어, 인용할 문장, 관련 맥락을 정리한다.
2. 블로그 초안은 `content/posts/` 아래에 새 Markdown 파일로 작성한다.
3. 사용자가 명시적으로 원하지 않는다고 하지 않는 한 대표 이미지를 함께 생성한다.
   - 대표 이미지 크기: **1000 x 300 px**
   - 저장 위치: `assets/images/`
   - 형식: PNG
   - 파일명: post slug와 동일한 kebab-case
   - front matter에 `featuredImage = 'images/<post-slug>.png'`를 추가한다.
4. 초안 front matter에는 반드시 `draft = true`를 넣는다.

```toml
+++
title = 'Draft Title'
date = 2026-05-26
draft = true
authors = ['Sungsik']
categories = ['C++']
tags = ['Draft']
featuredImage = 'images/draft-title.png'
+++
```

5. 원본 Obsidian 문서에 새 블로그 문서가 나중에 웹에 렌더링될 주소를 링크로 추가한다.
   - 기본 주소 형식: `http://jmyl.github.io/posts/<post-slug>/`
   - `<post-slug>`는 `content/posts/<post-slug>.md`의 파일명에서 `.md`를 뺀 값이다.
   - 예: `content/posts/protocol-handler-tests.md` → `http://jmyl.github.io/posts/protocol-handler-tests/`
6. Obsidian 문서에는 중복 추가를 피하고, 이미 같은 블로그 링크가 있으면 갱신하거나 그대로 둔다.
7. 원본 Obsidian 내용을 그대로 대량 복사하지 말고, 필요한 부분만 인용/재구성해서 블로그 글로 다듬는다.

Obsidian 문서에 추가할 링크 예시:

```markdown

---
Blog draft: [Protocol Handler Tests](http://jmyl.github.io/posts/protocol-handler-tests/)
```

## 자동 생성 이미지 Workflow

대표 이미지는 새 글 작성 시 기본으로 생성한다. 단, 사용자가 명시적으로 원하지 않는다고 한 경우에는 생략한다. 생성/추가 시 아래 규칙을 따른다.

- 대표 이미지 크기: **1000 x 300 px**
- 저장 위치: `assets/images/`
- SVG 금지. 생성 결과는 PNG를 우선 사용한다.
- 파일명은 글 slug와 맞춘 kebab-case 권장
  - 예: `content/posts/protocol-handler-tests.md`
  - 예: `assets/images/protocol-handler-tests.png`
- front matter에는 `assets/`를 제외한 경로를 넣는다.

```toml
featuredImage = 'images/protocol-handler-tests.png'
```

## 작성 후 확인

가능하면 변경 후 아래 명령으로 Hugo 빌드/미리보기를 확인한다.

```bash
hugo serve
```

또는 빌드만 확인한다.

```bash
hugo
```

## 참고 커밋

`d0e89a7` 커밋의 구성:

```text
content/posts/protocol-handler-tests.md
assets/images/protocol-handler-transport-independent.png
```

이 패턴을 새 글 추가의 기준 예시로 삼는다.
