Main Server README

1. server.conf - openvpn server configuration file
2. client1.conf - openvpn client configuration file
3. dhcpd.conf - dhcp server configuration file
4. bridge-conf, server_start.sh, server-stop.sh - tap interface open, dhcp server, openvpn server start

1. server.conf
(sudo) openvpn server.conf 명령어로 서버 시작
참조 : https://openvpn.net/community-resources/how-to/#openvpn-quickstart
openvpn 실행 시 위 파일의 설정대로 서버를 시작
tcp/udp, 사용 포트, 사용되는 암호, client-to-client 허용 등의 다양한 옵션 설정 가능

2. client1.conf
(sudo) openvpn client1.conf 명령어로 클라이언트 시작
client 모드 설정파일이기 때문에 서버의 ip 주소와 포트 설정 필요
사용되는 암호와 필요한 기타 설정들을 서버와 동일하게 설정해야 함

3. dhcpd.conf
(sudo) dhcpd 명령어로 dhcp 서버 실행(/etc/dhcp/ 혹은 /etc/ 에 dhcpd.conf 파일이 있어야 함)
* 처음 서버를 실행할 때 /etc/dhcp/dhcpd.lease 파일이 존재해야 한다. touch 명령어를 통해 만들어준다.
  접근 권한이 없다고 나올 때는 chmod -R 777 /etc/dhcp/dhcpd.lease 명령어로 접근 권한을 풀어준다.
참조 : https://www.tecmint.com/install-dhcp-server-in-ubuntu-debian/
전역 명령어 혹은 subnet을 설정하여 dhcp 서버 설정
dns 주소, dhcp 서버의 ip, 할당할 ip 영역 등을 설정 가능

4. 쉘 파일들
tap0 인터페이스를 개방하고 난 후에 server.conf 파일을 통해 openvpn 서버를 연결하고, dhcpd 명령어로 dhcp 서버를 연결한다.