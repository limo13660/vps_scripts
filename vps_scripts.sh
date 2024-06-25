#!/bin/bash
# 定义颜色
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[1;34m'
PURPLE='\033[0;35m'
WHITE='\033[1;37m'
NC='\033[0m'  # No Color

# 定义渐变颜色数组
colors=(
    '\033[38;2;0;255;0m'    # 绿色
    '\033[38;2;64;255;0m'
    '\033[38;2;128;255;0m'
    '\033[38;2;192;255;0m'
    '\033[38;2;255;255;0m'  # 黄色
    '\033[38;2;255;192;0m'
    '\033[38;2;255;128;0m'
    '\033[38;2;255;64;0m'
    '\033[38;2;255;0;0m'    # 红色
)

# 检查 root 权限
if [ "$(id -u)" != "0" ]; then
    echo -e "${RED}此脚本需要 root 权限运行。${NC}"
    exit 1
fi

# 获取当前服务器ipv4和ipv6
ip_address() {
    ipv4_address=$(curl -s ipv4.ip.sb)
    ipv6_address=$(curl -s --max-time 1 ipv6.ip.sb)
}

# 等待用户返回
break_end() {
    echo -e "${GREEN}执行完成${NC}"
    echo -e "${YELLOW}按任意键返回...${NC}"
    read -n 1 -s -r -p ""
    echo ""
    clear
}

# 定义脚本URL和版本URL
SCRIPT_URL="https://raw.githubusercontent.com/everett7623/vps_scripts/main/vps_scripts.sh"
VERSION_URL="https://raw.githubusercontent.com/everett7623/vps_scripts/main/version.txt"
CURRENT_VERSION="v2024.06.24" # 假设当前版本是 v2024.06.24

# 获取远程版本
REMOTE_VERSION=$(curl -s $VERSION_URL)

# 比较版本号
if [ "$REMOTE_VERSION" != "$CURRENT_VERSION" ]; then
    echo -e "${BLUE}发现新版本，正在更新...${NC}"
    # 下载并替换脚本
    curl -s -o /tmp/vps_scripts.sh $SCRIPT_URL
    if [ $? -eq 0 ]; then
        mv /tmp/vps_scripts.sh $0
        echo -e "${GREEN}脚本更新成功！${NC}"
        # 重新运行脚本
        exec bash $0
    else
        echo -e "${RED}脚本更新失败！${NC}"
        exit 1
    fi
else
    echo -e "${GREEN}脚本已是最新版本。${NC}"
fi

# 统计使用次数
sum_run_times() {
    local COUNT
    COUNT=$(wget --no-check-certificate -qO- --tries=2 --timeout=2 "https://hits.seeyoufarm.com/api/count/incr/badge.svg?url=https%3A%2F%2Fgithub.com%2Feverett7623%2Fvps_scripts%2Fblob%2Fmain%2Fvps_scripts.sh" 2>&1 | grep -m1 -oE "[0-9]+[ ]+/[ ]+[0-9]+")
    if [[ -n "$COUNT" ]]; then
        daily_count=$(cut -d " " -f1 <<< "$COUNT")
        total_count=$(cut -d " " -f3 <<< "$COUNT")
    else
        echo "Failed to fetch usage counts."
        daily_count=0
        total_count=0
    fi
}

# 调用函数获取统计数据
sum_run_times

while true; do
clear
# 输出欢迎信息
echo -e "今日运行次数: ${RED}$daily_count${NC} 次，累计运行次数: ${RED}$total_count${NC} 次"
echo ""
echo -e "${YELLOW}---------------------------------By'Jensfrank---------------------------------${NC}"
echo ""
echo "VPS脚本集合 v2024.06.24"
echo "GitHub地址: https://github.com/everett7623/vps_scripts"
echo "VPS选购: https://www.nodeloc.com/vps"
echo ""
echo -e "${colors[0]} #     # #####   #####       #####   #####  #####   ### #####  #####  #####  ${NC}"
echo -e "${colors[1]} #     # #    # #     #     #     # #     # #    #   #  #    #   #   #     # ${NC}"
echo -e "${colors[2]} #     # #    # #           #       #       #    #   #  #    #   #   #       ${NC}"
echo -e "${colors[3]} #     # #####   #####       #####  #       #####    #  #####    #    #####  ${NC}"
echo -e "${colors[4]}  #   #  #            #           # #       #   #    #  #        #         # ${NC}"
echo -e "${colors[3]}   # #   #      #     #     #     # #     # #    #   #  #        #   #     # ${NC}"
echo -e "${colors[2]}    #    #       #####       #####   #####  #     # ### #        #    #####  ${NC}"
echo ""
echo "支持Ubuntu/Debian"
echo -e "快捷键已设置为${RED}v${NC},下次运行输入${RED}v${NC}可快速启动此脚本"
echo ""
echo -e "${YELLOW}---------------------------------By'Jensfrank---------------------------------${NC}"
echo ""

# 检查并安装依赖
echo "检查并安装必要的依赖项..."

# 检查和安装 curl
if ! command -v curl &> /dev/null; then
    echo "curl 未安装，正在安装..."
    sudo apt-get update && sudo apt-get install -y curl
else
    echo "curl 已安装"
fi

# 检查和安装 wget
if ! command -v wget &> /dev/null; then
    echo "wget 未安装，正在安装..."
    sudo apt-get update && sudo apt-get install -y wget
else
    echo "wget 已安装"
fi

echo "依赖项安装完成。"

# 主菜单
while true; do
  echo ""
  echo -e "${GREEN}VPS管理脚本${NC}"
  echo -e "${YELLOW}1) 本机信息${NC}"
  echo -e "${YELLOW}2) 更新系统${NC}"
  echo -e "${YELLOW}3) 清理系统${NC}"
  echo -e "${YELLOW}4) Yabs${NC}"
  echo -e "${YELLOW}5) 融合怪${NC}"
  echo -e "${YELLOW}6) IP质量${NC}"
  echo -e "${YELLOW}7) 流媒体解锁${NC}"
  echo -e "${YELLOW}8) 响应测试${NC}"
  echo -e "${YELLOW}9) 三网测速（多/单线程）${NC}"
  echo -e "${YELLOW}10) 安装并启动iperf3服务端 ${NC}"
  echo -e "${YELLOW}11) AutoTrace三网回程路由${NC}"
  echo -e "${YELLOW}12) 超售测试${NC}"
  echo -e "${YELLOW}20) VPS一键脚本工具箱${NC}"
  echo -e "${YELLOW}21) jcnf 常用脚本工具包${NC}"
  echo -e "${YELLOW}22) 科技lion脚本${NC}"
  echo -e "${YELLOW}23) BlueSkyXN脚本${NC}"
  echo -e "${YELLOW}30) 勇哥Singbox${NC}"
  echo -e "${YELLOW}31) 勇哥x-ui${NC}"
  echo -e "${YELLOW}32) Fscarmen-Singbox${NC}"
  echo -e "${YELLOW}33) Mack-a八合一${NC}"
  echo -e "${YELLOW}34) Warp集合${NC}"
  echo -e "${YELLOW}40) 安装docker${NC}"
  echo -e "${YELLOW}0) 退出${NC}"
  
  read -p "输入数字选择对应的脚本: " choice

  case $choice in
    1)
      clear
      echo -e "${YELLOW}执行本机信息...${NC}"

      ipv4_address=$(curl -s http://ipinfo.io/ip)
      ipv6_address=$(curl -s http://ip6.me/ | awk -F "[<,>]" '/ip_address/{print $3}')

      if [ "$(uname -m)" == "x86_64" ]; then
        cpu_info=$(cat /proc/cpuinfo | grep 'model name' | uniq | sed -e 's/model name[[:space:]]*: //')
      else
        cpu_info=$(lscpu | grep 'Model name' | sed -e 's/Model name[[:space:]]*: //')
      fi

      cpu_usage=$(top -bn1 | grep 'Cpu(s)' | awk '{print $2 + $4}')
      cpu_usage_percent=$(printf "%.2f" "$cpu_usage")%

      cpu_cores=$(nproc)

      mem_info=$(free -b | awk 'NR==2{printf "%.2f/%.2f MB (%.2f%%)", $3/1024/1024, $2/1024/1024, $3*100/$2}')

      disk_info=$(df -h | awk '$NF=="/"{printf "%d/%dGB (%s)", $3,$2,$5}')

      country=$(curl -s ipinfo.io/country)
      city=$(curl -s ipinfo.io/city)

      isp_info=$(curl -s ipinfo.io/org)

      cpu_arch=$(uname -m)

      hostname=$(hostname)

      kernel_version=$(uname -r)

      congestion_algorithm=$(sysctl -n net.ipv4.tcp_congestion_control)
      queue_algorithm=$(sysctl -n net.core.default_qdisc)

      # 尝试使用 lsb_release 获取系统信息
      os_info=$(lsb_release -ds 2>/dev/null)

      # 如果 lsb_release 命令失败，则尝试其他方法
      if [ -z "$os_info" ]; then
        # 检查常见的发行文件
        if [ -f "/etc/os-release" ]; then
          os_info=$(source /etc/os-release && echo "$PRETTY_NAME")
        elif [ -f "/etc/debian_version" ]; then
          os_info="Debian $(cat /etc/debian_version)"
        elif [ -f "/etc/redhat-release" ]; then
          os_info=$(cat /etc/redhat-release)
        else
          os_info="Unknown"
        fi
      fi

      clear
      output=$(awk 'BEGIN { rx_total = 0; tx_total = 0 }
        NR > 2 { rx_total += $2; tx_total += $10 }
        END {
            rx_units = "Bytes";
            tx_units = "Bytes";
            if (rx_total > 1024) { rx_total /= 1024; rx_units = "KB"; }
            if (rx_total > 1024) { rx_total /= 1024; rx_units = "MB"; }
            if (rx_total > 1024) { rx_total /= 1024; rx_units = "GB"; }

            if (tx_total > 1024) { tx_total /= 1024; tx_units = "KB"; }
            if (tx_total > 1024) { tx_total /= 1024; tx_units = "MB"; }
            if (tx_total > 1024) { tx_total /= 1024; tx_units = "GB"; }

            printf("总接收: %.2f %s\n总发送: %.2f %s\n", rx_total, rx_units, tx_total, tx_units);
        }' /proc/net/dev)

      current_time=$(date "+%Y-%m-%d %I:%M %p")

      swap_used=$(free -m | awk 'NR==3{print $3}')
      swap_total=$(free -m | awk 'NR==3{print $2}')

      if [ "$swap_total" -eq 0 ]; then
        swap_percentage=0
      else
        swap_percentage=$((swap_used * 100 / swap_total))
      fi

      swap_info="${swap_used}MB/${swap_total}MB (${swap_percentage}%)"

      runtime=$(cat /proc/uptime | awk -F. '{run_days=int($1 / 86400);run_hours=int(($1 % 86400) / 3600);run_minutes=int(($1 % 3600) / 60); if (run_days > 0) printf("%d天 ", run_days); if (run_hours > 0) printf("%d时 ", run_hours); printf("%d分\n", run_minutes)}')

      echo ""
      echo -e "${WHITE}系统信息详情${NC}"
      echo "------------------------"
      echo -e "${WHITE}主机名: ${PURPLE}${hostname}${NC}"
      echo -e "${WHITE}运营商: ${PURPLE}${isp_info}${NC}"
      echo "------------------------"
      echo -e "${WHITE}系统版本: ${PURPLE}${os_info}${NC}"
      echo -e "${WHITE}Linux版本: ${PURPLE}${kernel_version}${NC}"
      echo "------------------------"
      echo -e "${WHITE}CPU架构: ${PURPLE}${cpu_arch}${NC}"
      echo -e "${WHITE}CPU型号: ${PURPLE}${cpu_info}${NC}"
      echo -e "${WHITE}CPU核心数: ${PURPLE}${cpu_cores}${NC}"
      echo "------------------------"
      echo -e "${WHITE}CPU占用: ${PURPLE}${cpu_usage_percent}${NC}"
      echo -e "${WHITE}物理内存: ${PURPLE}${mem_info}${NC}"
      echo -e "${WHITE}虚拟内存: ${PURPLE}${swap_info}${NC}"
      echo -e "${WHITE}硬盘占用: ${PURPLE}${disk_info}${NC}"
      echo "------------------------"
      echo -e "${PURPLE}$output${NC}"
      echo "------------------------"
      echo -e "${WHITE}网络拥堵算法: ${PURPLE}${congestion_algorithm} ${queue_algorithm}${NC}"
      echo "------------------------"
      echo -e "${WHITE}公网IPv4地址: ${PURPLE}${ipv4_address}${NC}"
      echo -e "${WHITE}公网IPv6地址: ${PURPLE}${ipv6_address}${NC}"
      echo "------------------------"
      echo -e "${WHITE}地理位置: ${PURPLE}${country} ${city}${NC}"
      echo -e "${WHITE}系统时间: ${PURPLE}${current_time}${NC}"
      echo "------------------------"
      echo -e "${WHITE}系统运行时长: ${PURPLE}${runtime}${NC}"
      echo
      ;;
    2)
      clear
      echo -e "${YELLOW}执行 更新系统...${NC}"
      update_system() {
        if command -v apt &>/dev/null; then
          apt-get update && apt-get upgrade -y
        elif command -v dnf &>/dev/null; then
          dnf check-update && dnf upgrade -y
        elif command -v yum &>/dev/null; then
          yum check-update && yum upgrade -y
        elif command -v apk &>/dev/null; then
          apk update && apk upgrade
        else
          echo -e "${RED}不支持的Linux发行版${NC}"
          return 1
        fi
        return 0
      }
      update_system
      ;;
    3)
      clear
      echo -e "${YELLOW}执行 清理系统...${NC}"
      clean_system() {
        if command -v apt &>/dev/null; then
          apt autoremove --purge -y && apt clean -y && apt autoclean -y
          apt remove --purge $(dpkg -l | awk '/^rc/ {print $2}') -y
          journalctl --vacuum-time=1s
          journalctl --vacuum-size=50M
          apt remove --purge $(dpkg -l | awk '/^ii linux-(image|headers)-[^ ]+/{print $2}' | grep -v $(uname -r | sed 's/-.*//')) -y
        elif command -v yum &>/dev/null; then
          yum autoremove -y && yum clean all
          journalctl --vacuum-time=1s
          journalctl --vacuum-size=50M
          yum remove $(rpm -q kernel | grep -v $(uname -r)) -y
        elif command -v dnf &>/dev/null; then
          dnf autoremove -y && dnf clean all
          journalctl --vacuum-time=1s
          journalctl --vacuum-size=50M
          dnf remove $(rpm -q kernel | grep -v $(uname -r)) -y
        elif command -v apk &>/dev/null; then
          apk autoremove -y
          apk clean
          journalctl --vacuum-time=1s
          journalctl --vacuum-size=50M
          apk del $(apk info -e | grep '^r' | awk '{print $1}') -y
        else
          echo -e "${RED}暂不支持你的系统！${NC}"
          exit 1
        fi
      }
      clean_system
      ;;
    4)
      clear
      echo -e "${YELLOW}执行 Yabs 脚本...${NC}"
      wget -qO- yabs.sh | bash
      ;;
    5)
      clear
      echo -e "${YELLOW}执行 融合怪 脚本...${NC}"
      curl -L https://gitlab.com/spiritysdx/za/-/raw/main/ecs.sh -o ecs.sh && chmod +x ecs.sh && bash ecs.sh
      ;;
    6)
      clear
      echo -e "${YELLOW}执行 IP质量 脚本...${NC}"
      bash <(curl -Ls IP.Check.Place)
      ;;
    7)
      clear
      echo -e "${YELLOW}执行 流媒体解锁 脚本...${NC}"
      bash <(curl -L -s media.ispvps.com)
      ;;
    8)
      clear
      echo -e "${YELLOW}执行 响应测试 脚本...${NC}"
      bash <(curl -sL https://nodebench.mereith.com/scripts/curltime.sh)
      ;;
    9)
      clear
      echo -e "${YELLOW}执行 三网测速（多/单线程） 脚本...${NC}"
      bash <(curl -sL bash.icu/speedtest)
      ;;
    10)
      clear
      echo -e "${YELLOW}执行 安装并启动iperf3服务端 脚本...${NC}"
      echo ""
      echo "客户端操作，比如Windows："
      echo -e "${RED}iperf3客户端下载地址 (https://iperf.fr/iperf-download.php)${NC}"
      echo "在Windows电脑上，下载iperf3 Windows版本，解压到任意目录，例如D:\iperf3"
      echo "打开命令提示符窗口，切换到iperf3目录:"
      echo "cd D:\iperf3"
      
      echo ""
      echo -e "${BLUE}执行客户端命令，连接到VPS的IP:${NC}"
      echo -e "iperf3.exe -c ${RED}vps_ip${NC}"
      echo "它会进行10秒的默认TCP下载测试。"
      echo "案例：.\iperf3.exe -c 104.234.111.111"

      echo ""
      echo -e "${BLUE}单线程上传测试:${NC}"
      echo -e "iperf3.exe -c ${RED}vps_ip${NC} -R"
      echo "该命令会测试从客户端到服务端VPS的上传带宽。"
      echo "案例：.\iperf3.exe -c 104.234.111.111 -R"

      echo ""
      echo -e "${BLUE}多线程下载测试:${NC}"
      echo -e "iperf3.exe -c ${RED}vps_ip${NC}  -P 4"
      echo "这会运行一个4个流并行下载测试。"
      echo "案例：.\iperf3.exe -c 104.234.111.111 -P 4"

      echo ""
      echo -e "${BLUE}多线程上传测试:${NC}"
      echo -e "iperf3.exe -c ${RED}vps_ip${NC}  -R -P 4"
      echo "案例：.\iperf3.exe -c 104.234.111.111 -R -P 4"

      echo ""
      echo -e "${BLUE}长时间下载测试:${NC}"
      echo -e "iperf3.exe -c ${RED}vps_ip${NC}  -t 60"
      echo "该命令会测试60秒的长时间下载，观察带宽变化。"
      echo "案例：.\iperf3.exe -c 104.234.111.111 -t 60"

      echo ""
      echo -e "${BLUE}UDP模拟视频流测试:${NC}"
      echo -e "iperf3.exe -c ${RED}vps_ip${NC}  -u -b 200m"
      echo "以200mbps的码率，测试UDP下载/模拟视频流。"
      echo "您也可以根据实际需求调整目标带宽-b值。"
      echo "案例：.\iperf3.exe -c 104.234.111.111 -u -b 200m"

      echo ""
      echo -e "${BLUE}其他参数示例:${NC}"
      echo -e ".\iperf3.exe -c ${RED}vps_ip${NC}  -i 1       # 每1秒输出带宽报告"
      echo -e ".\iperf3.exe -c ${RED}vps_ip${NC}  -p 5201    # 指定服务端端口为5201"

      echo -e "${BLUE}上面的操作是客户端操作案例，下面启动服务端iperf3服务端:${NC}"
      echo "不加任何参数，则默认监听TCP端口5201"
      echo -e "${BLUE}等待看到服务端监听端口5201后 回到客户端按照案例操作即可:${NC}"
      apt-get install -y iperf3
      iperf3 -s
      ;;
    11)
      clear
      echo -e "${YELLOW}执行 AutoTrace三网回程路由 脚本...${NC}"
      wget -N --no-check-certificate https://raw.githubusercontent.com/Chennhaoo/Shell_Bash/master/AutoTrace.sh && chmod +x AutoTrace.sh && bash AutoTrace.sh
      ;;
    12)
      clear
      echo -e "${YELLOW}执行 超售测试脚本...${NC}"
      wget --no-check-certificate -O memoryCheck.sh https://raw.githubusercontent.com/uselibrary/memoryCheck/main/memoryCheck.sh && chmod +x memoryCheck.sh && bash memoryCheck.sh
      ;;
    20)
      clear
      echo -e "${YELLOW}执行 VPS一键脚本工具箱 脚本...${NC}"
      curl -fsSL https://raw.githubusercontent.com/eooce/ssh_tool/main/ssh_tool.sh -o ssh_tool.sh && chmod +x ssh_tool.sh && ./ssh_tool.sh
      ;;
    21)
      clear
      echo -e "${YELLOW}执行 jcnf 常用脚本工具包 脚本...${NC}"
      wget -O jcnfbox.sh https://raw.githubusercontent.com/Netflixxp/jcnf-box/main/jcnfbox.sh && chmod +x jcnfbox.sh && clear && ./jcnfbox.sh
      ;;
    22)
      clear
      echo -e "${YELLOW}执行 科技lion脚本...${NC}"
      curl -sS -O https://raw.githubusercontent.com/kejilion/sh/main/kejilion.sh && chmod +x kejilion.sh && ./kejilion.sh
      ;;
    23)
      clear
      echo -e "${YELLOW}执行 BlueSkyXN脚本...${NC}"
      wget -O box.sh https://raw.githubusercontent.com/BlueSkyXN/SKY-BOX/main/box.sh && chmod +x box.sh && clear && ./box.sh
      ;;
    30)
      clear
      echo -e "${YELLOW}执行 勇哥Singbox 脚本...${NC}"
      bash <(curl -Ls https://gitlab.com/rwkgyg/sing-box-yg/raw/main/sb.sh)
      ;;
    31)
      clear
      echo -e "${YELLOW}执行 勇哥x-ui 脚本...${NC}"
      bash <(curl -Ls https://gitlab.com/rwkgyg/x-ui-yg/raw/main/install.sh)
      ;;
    32)
      clear
      echo -e "${YELLOW}执行 Fscarmen-Singbox 脚本...${NC}"
      bash <(wget -qO- https://raw.githubusercontent.com/fscarmen/sba/main/sba.sh)
      ;;
    33)
      clear
      echo -e "${YELLOW}执行 Mack-a八合一 脚本...${NC}"
      wget -P /root -N --no-check-certificate "https://raw.githubusercontent.com/mack-a/v2ray-agent/master/install.sh" && chmod 700 /root/install.sh && /root/install.sh
      ;;
    34)
      clear
      echo -e "${YELLOW}执行 Warp集合 脚本...${NC}"
      bash <(curl -sSL https://gitlab.com/fscarmen/warp_unlock/-/raw/main/unlock.sh)
      ;;
    40)
      clear
      echo -e "${YELLOW}执行 安装docker 脚本...${NC}"
      curl -fsSL https://get.docker.com | bash -s docker
      ;;
    0)
      echo -e "${YELLOW}退出...${NC}"
      clear
      exit
      ;;
    *)
      echo -e "${purple}无效的输入!${NC}"
      ;;
esac
      break_end
done
