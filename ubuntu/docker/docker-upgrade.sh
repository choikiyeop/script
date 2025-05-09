#!/bin/bash
# 특정 이미지를 사용하는 컨테이너의 버전을 업그레이드하는 간단한 명령어

# 대상 이미지 이름 (예: nginx, mysql 등)
IMAGE_NAME=$1

if [ -z "$IMAGE_NAME" ]; then
    echo "사용법: $0 이미지이름[:태그]"
    exit 1
fi

# 최신 이미지 가져오기
docker pull $IMAGE_NAME

# 해당 이미지를 사용중인 컨테이너 ID 가져오기
CONTAINER_IDS=$(docker ps -q --filter ancestor=$IMAGE_NAME)

if [ -z "$CONTAINER_IDS" ]; then
    echo "이미지 $IMAGE_NAME를 사용하는 실행 중인 컨테이너가 없습니다."
    exit 0
fi

# 각 컨테이너 업데이트
for ID in $CONTAINER_IDS; do
    CONTAINER_NAME=$(docker inspect --format='{{.Name}}' $ID | sed 's/\///')
    echo "컨테이너 업데이트 중: $CONTAINER_NAME ($ID)"
    
    # 컨테이너 재시작 (새 이미지 사용)
    docker stop $ID
    docker rm $ID
    
    # 동일한 설정으로 새 컨테이너 생성 및 실행
    docker run --name $CONTAINER_NAME \
        $(docker inspect --format='{{range $p, $conf := .NetworkSettings.Ports}}{{if $conf}}{{range $conf}}-p {{.HostIp}}:{{.HostPort}}:{{$p}} {{end}}{{end}}{{end}}' $ID) \
        $(docker inspect --format='{{range .Mounts}}--mount type={{.Type}},source={{.Source}},target={{.Destination}} {{end}}' $ID) \
        $(docker inspect --format='{{range .Config.Env}}--env {{.}} {{end}}' $ID) \
        $(docker inspect --format='{{range $net, $v := .NetworkSettings.Networks}}--network {{$net}} {{end}}' $ID) \
        $(docker inspect --format='{{if ne .HostConfig.RestartPolicy.Name "no"}}--restart {{.HostConfig.RestartPolicy.Name}} {{end}}' $ID) \
        -d $IMAGE_NAME
        
    echo "컨테이너 $CONTAINER_NAME 업데이트 완료"
done

echo "모든 컨테이너 업데이트 완료"
