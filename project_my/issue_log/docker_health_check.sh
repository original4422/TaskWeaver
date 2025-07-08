#!/bin/bash

# TaskWeaver Docker环境健康检查脚本
# 创建时间: 2025-07-08
# 用途: 定期检查TaskWeaver Docker环境状态

echo "=================================================="
echo "TaskWeaver Docker环境健康检查"
echo "检查时间: $(date)"
echo "=================================================="
echo

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# 检查结果统计
PASS_COUNT=0
FAIL_COUNT=0

# 检查函数
check_result() {
    if [ $1 -eq 0 ]; then
        echo -e "${GREEN}✅ 通过${NC}"
        ((PASS_COUNT++))
    else
        echo -e "${RED}❌ 失败${NC}"
        ((FAIL_COUNT++))
    fi
}

# 1. 检查Docker版本
echo -e "${BLUE}1. Docker版本检查:${NC}"
docker --version
check_result $?
echo

# 2. 检查Docker基本功能
echo -e "${BLUE}2. Docker基本功能测试:${NC}"
docker run --rm hello-world > /dev/null 2>&1
check_result $?
echo

# 3. 检查TaskWeaver镜像
echo -e "${BLUE}3. TaskWeaver镜像检查:${NC}"
docker images | grep taskweaver
if [ $? -eq 0 ]; then
    echo -e "${GREEN}✅ TaskWeaver镜像存在${NC}"
    ((PASS_COUNT++))
else
    echo -e "${RED}❌ TaskWeaver镜像不存在${NC}"
    ((FAIL_COUNT++))
fi
echo

# 4. 检查当前运行的TaskWeaver容器
echo -e "${BLUE}4. TaskWeaver容器状态:${NC}"
RUNNING_CONTAINERS=$(docker ps | grep taskweaver | wc -l)
if [ $RUNNING_CONTAINERS -gt 0 ]; then
    echo -e "${GREEN}✅ 发现 $RUNNING_CONTAINERS 个运行中的TaskWeaver容器${NC}"
    docker ps | grep taskweaver
    ((PASS_COUNT++))
else
    echo -e "${YELLOW}⚠️  没有运行中的TaskWeaver容器${NC}"
    ((FAIL_COUNT++))
fi
echo

# 5. 测试Python执行
echo -e "${BLUE}5. Python容器执行测试:${NC}"
docker run --rm --entrypoint="" taskweavercontainers/taskweaver-executor:latest python3 -c "print('Python执行正常')" > /dev/null 2>&1
check_result $?
echo

# 6. 检查磁盘空间
echo -e "${BLUE}6. Docker磁盘使用情况:${NC}"
docker system df
echo

# 7. 检查TaskWeaver进程
echo -e "${BLUE}7. TaskWeaver进程检查:${NC}"
TASKWEAVER_PROCESSES=$(ps aux | grep taskweaver | grep -v grep | wc -l)
if [ $TASKWEAVER_PROCESSES -gt 0 ]; then
    echo -e "${GREEN}✅ 发现 $TASKWEAVER_PROCESSES 个TaskWeaver进程${NC}"
    ps aux | grep taskweaver | grep -v grep
    ((PASS_COUNT++))
else
    echo -e "${YELLOW}⚠️  没有运行中的TaskWeaver进程${NC}"
    ((FAIL_COUNT++))
fi
echo

# 8. 检查最近的TaskWeaver日志
echo -e "${BLUE}8. 最近的TaskWeaver日志:${NC}"
TASKWEAVER_LOG="/home/original_22_04/LLM_agent/TaskWeaver/project/logs/task_weaver.log"
if [ -f "$TASKWEAVER_LOG" ]; then
    echo -e "${GREEN}✅ 日志文件存在${NC}"
    echo "最近的5条日志:"
    tail -5 "$TASKWEAVER_LOG"
    ((PASS_COUNT++))
else
    echo -e "${RED}❌ 日志文件不存在: $TASKWEAVER_LOG${NC}"
    ((FAIL_COUNT++))
fi
echo

# 总结报告
echo "=================================================="
echo -e "${BLUE}健康检查总结:${NC}"
echo -e "通过项目: ${GREEN}$PASS_COUNT${NC}"
echo -e "失败项目: ${RED}$FAIL_COUNT${NC}"

TOTAL_CHECKS=$((PASS_COUNT + FAIL_COUNT))
SUCCESS_RATE=$((PASS_COUNT * 100 / TOTAL_CHECKS))

if [ $SUCCESS_RATE -ge 80 ]; then
    echo -e "整体状态: ${GREEN}✅ 健康 ($SUCCESS_RATE%)${NC}"
    exit 0
elif [ $SUCCESS_RATE -ge 60 ]; then
    echo -e "整体状态: ${YELLOW}⚠️  警告 ($SUCCESS_RATE%)${NC}"
    exit 1
else
    echo -e "整体状态: ${RED}❌ 需要关注 ($SUCCESS_RATE%)${NC}"
    exit 2
fi

echo "==================================================" 