# from concurrent.futures.thread import ThreadPoolExecutor
# import time
from socketserver import BaseRequestHandler, ThreadingTCPServer
import json
import logging
import logging.handlers
import os
from subprocess import check_output

# CONSTANT = {
#     "1": 0,  # u盘线程
#     "2": 0,  # websocket 线程
#     "3": 0,  # 打印机热插拔线程
#     "4": 0,  # qt 进程
#     "5": 0,  # 升级 进程
#     "6": 0,  # 接收PC端文件传输 线程
# }


class Constant:
    ws = '2'
    printer = '3'
    qt = '4'
    upgrade = "5"
    file_server = "6"


ws_t = 0
printer_t = 0
qt_t = 0
upgrade_t = 0
fs_t = 0

reload_cmd_set = set()


def get_now_time():
    cmd = "cat /proc/uptime | awk -F. '{printf $1}'"
    return int(check_output(cmd, shell=True))


INIT_TIME = get_now_time()
PRINTER_CHECK_TIME = INIT_TIME
BROWSER_CHECK_TIME = INIT_TIME
SYS_UPGRADE_CHECK_TIME = INIT_TIME
LOG_CHECK_TIME = INIT_TIME
PRINT_SPLIT_TIME = 10


LOG_SIZE = 10*1024*1024  # 设置单个日志最大为10M
LOG_BACKUP_COUNT = 2  # 设置最多备份2个日志文件
LOG_FORMAT = "[%(asctime)s][%(levelname)s][%(lineno)s]: %(message)s"
LEVEL = logging.ERROR
# LOG_FILENAME = "/etc/init.d/script/watchdog.log"
workspace_path = "/usr/share/"
LOG_FILENAME = workspace_path + "script/watchdog.log"


class MyThreadingTCPServer(ThreadingTCPServer):
    """重写socketserver.ThreadingTCPServer"""
    # 服务停止后即刻释放端口，无需等待tcp连接断开
    allow_reuse_address = True


class Handler(BaseRequestHandler):
    def handle(self):
        global ws_t
        global printer_t
        global qt_t
        global upgrade_t
        global PRINTER_CHECK_TIME
        global LOG_CHECK_TIME
        global BROWSER_CHECK_TIME
        global SYS_UPGRADE_CHECK_TIME
        global fs_t
        now_time = get_now_time()
        try:
            data = self.request.recv(1024)
            current_data = data.decode("utf-8")

            if current_data == Constant.printer:
                printer_t = now_time
                PRINTER_CHECK_TIME = now_time
            elif current_data == Constant.qt:
                qt_t = now_time
            elif current_data == Constant.upgrade:
                upgrade_t = now_time
                js_data = {
                    Constant.ws: ws_t,
                    Constant.printer: printer_t,
                    Constant.qt: qt_t,
                    Constant.upgrade: upgrade_t,
                    Constant.file_server: fs_t,
                }
                logging.debug("now_time:{}, js_data:{}".format(now_time, js_data))
                self.request.sendall(json.dumps(js_data).encode('utf-8'))

        except Exception as e:
            logging.error(e)
        finally:
            self.request.close()

            # TODO:伪代码 根据时间间隔拉取相应没有启动的线程
            if reload_cmd_set:
                while reload_cmd_set:
                    cmd = reload_cmd_set.pop()
                    logging.error(cmd)
                    os.system(cmd)
            else:
                # 检测浏览器5秒 4 + 前面休眠的1秒
                if now_time - BROWSER_CHECK_TIME > 4:
                    BROWSER_CHECK_TIME = now_time
                    if now_time > qt_t + 20:
                        # 记录内存情况
                        from subprocess import check_output
                        cmd = "memory_used_tool.sh"
                        ret = check_output(cmd, shell=True).decode().strip("\n")
                        date_info = check_output("date", shell=True).decode().strip("\r").strip("\n")
                        logging.error("time:%s\nmem info before reload browser:\n %s" % (date_info, ret))
                        # 重启浏览器
                        BROWSER_CHECK_TIME = now_time + 15
                        restart_cmd = "/etc/init.d/browser reload  >/dev/null 2>&1"
                        logging.error("will use cmd:{}, qt_t:{}".format(restart_cmd, qt_t))
                        reload_cmd_set.add(restart_cmd)
                        # qt崩溃内核日志处理
                        try:
                            from subprocess import call, check_output
                            files_dir = os.listdir("/tmp")
                            dst_path = "/mnt/UDISK/.crealityprint/qt_core"
                            if not os.path.exists(dst_path):
                                os.makedirs(dst_path)
                            # qt崩溃文件占用空间过多时，进行清空
                            file_size_info = check_output("du -sh %s" % dst_path, shell=True).decode().strip("\r").strip("\n")
                            if "G" in file_size_info:
                                # 包含G时，表明空间占用已经超过1G
                                call("rm %s/*" % dst_path, shell=True)
                                call("sync", shell=True)
                            for obj in files_dir:
                                if obj.endswith(".core"):
                                    call("mv /tmp/%s %s" % (obj, dst_path), shell=True)
                                    date_info = check_output("date", shell=True).decode().strip("\r").strip("\n")
                                    file_info = "time:%s, file_name:%s" % (date_info, obj)
                                    call("echo '%s' >> %s/readme.md" % (file_info, dst_path), shell=True)
                                    call("sync", shell=True)
                        except Exception as err:
                            pass


def log_config():
    logging.basicConfig(level=LEVEL, format=LOG_FORMAT)

    log_file_handler = logging.handlers.RotatingFileHandler(LOG_FILENAME,
                                                            maxBytes=LOG_SIZE, backupCount=LOG_BACKUP_COUNT)
    # 设置日志打印格式
    formatter = logging.Formatter(LOG_FORMAT)
    log_file_handler.setFormatter(formatter)
    logging.getLogger('').addHandler(log_file_handler)


def main():
    log_config()
    logging.error("enter watch dog...")
    with MyThreadingTCPServer(('127.0.0.1', 9090), Handler) as server:
        server.serve_forever()
        server.shutdown()


if __name__ == '__main__':
    main()


