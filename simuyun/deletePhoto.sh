#! /bin/bash
for i in `find . -name "*.png" -o -name "*.jpg"`; do
file=`basename -s .jpg "$i" | xargs basename -s .png | xargs basename -s @2x`

result=`ack -i "$file"`
if [ -z "$result" ]; then
echo "$i"
# 如果需要，可以直接执行删除：
# rm "$i"
fi
done