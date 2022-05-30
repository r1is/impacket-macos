#!/bin/sh

file_url="https://github.com/SecureAuthCorp/impacket.git"
file_name="impacket"

# 下载impacket文件
git clone ${file_url}

if [ $? -ne 0 ];then
    exit -1
fi

sudo mv $file_name /opt
cd /opt/${file_name} && sudo chown -R $(whoami):staff /opt/${file_name}

script_file="script"
cat >${script_file}<<EOF
#!/bin/sh

name_script=\$(basename \$0)
example_name=\${name_script##impacket-}

exec python3 /opt/impacket/examples/\$example_name.py "\$@"
EOF
if [ -f "$script_file" ];then
    chmod +x $script_file && cat $script_file
else
    exit -1
fi

# 创建快捷方式 impacket-xxxx
src_py="/opt/impacket/${script_file}"
link="/usr/local/bin/impacket-"
for str in `ls examples`;do
    examples_name=`echo $str | awk -F'.' '{print($1)}'`
    ln -s ${src_py} ${link}${examples_name}
    chmod +x ${link}${examples_name}
done
sudo chown -R $(whoami):staff /usr/local/bin/impacket-*