#!/bin/bash

# 이미 설정된 alias 사용: cp, add, commit, push

echo "=== Git 자동화 작업 시작 ==="

set -e

# 1. cp (현재 디렉토리 복사 또는 다른 작업)
echo "1. cp 실행 중..."
cp -r ~/terraform_aws/ ~/github_repo/
sleep 0.5

# 2. ~/github_repo로 이동
echo "2. github_repo로 이동 중..."
cd ~/github_repo
sleep 0.5

# 3. add 실행
echo "3. add 실행 중..."
if git add ~/github_repo/terraform_aws/; then
	echo "================== add 완료 =================="
else
	echo "================== add 실패 =================="
	exit 1
fi
sleep 1

# 4. commit 실행
echo "4. commit 실행 중..."
if git commit -m "new"; then
	echo "================== commit 완료 =================="
else
	echo "================== commit 실패 =================="
	exit 1
fi
sleep 2

# 5. push 실행
echo "5. push 실행 중..."
if git push origin seminar; then
	echo "================== push 완료 =================="
else
	echo "================== push 실패 =================="
	exit 1
fi

echo "================== 모든 작업 완료! =================="
