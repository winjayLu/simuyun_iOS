修改理财师表，增加以下字段：
每个自有理财师
<groups>	组列表（最多五个）[{groupId: 'xxx', groupName: 'yyy'}]
每个受邀理财师
<grouped>	F给自己划分的分组列表（最多五个）
<memo>		自己给F的备注/F给自己的备注

提供接口：
--------------------------------------------------[获取团队根成员列表]
getAllMembers
参数：
{adviserId: adviserId}
返回值：返回参数理财师ID下的所有成员的信息
{
[
 {
#warning 添加"isFather"是否是推荐人(0/1),"headImgUrl"头像地址
     "isFather":"1",
     "headImgUrl": "http://wx.qlogo.cn/mmopen/ajNVdqHZLLDjDuGfZzBJ9ZVItVialdtwkGgZoFYicfoE3LBj54R7IkovtNagstSBmx9ZJpbzaARRQsoibwnuOMrFA/0",
     "lastLoginTime": "2015-01-01",
     "phoneNum": "13100000000",
     "memo": "memo1",
     "joinTeamTime": "2015-01-01",
     "nickName": "昵称", //nick_name -> nikeName
     "adviserId": "16f4af80b7e34ec6a1233894c71ef943"
 },
 ...
 ]

}


-- 查询组列表
getAllGroups
参数：
{adviserId: adviserId}
返回值：
{
    [
     {
     "groupId": "65f4af80b7e34ec6a1233894c71ef456",
     "groupName": "我的财富",
     "members": [
               {
                   "isFather":"1",
                   "headImgUrl": "http://wx.qlogo.cn/mmopen/ajNVdqHZLLDjDuGfZzBJ9ZVItVialdtwkGgZoFYicfoE3LBj54R7IkovtNagstSBmx9ZJpbzaARRQsoibwnuOMrFA/0",
                   "lastLoginTime": "2015-01-01",
                   "phoneNum": "1333331", //phone -> phoneNum
                   "memo": "memo1",
                   "joinTeamTime": "2015-01-01",
                   "nickName": "昵称",   //nick_name -> nikeName
                   "adviserId": "16f4af80b7e34ec6a1233894c71ef943"
               },
               ...
               ]
     },
     ...
     ]
}


// 去掉 [获取团队分组成员列表] 接口
//--------------------------------------------------[获取团队分组成员列表]


--------------------------------------------------[新建分组]
createGroup
创建分组后，在 <groups> 增加内容。
参数：
{"adviserId": "16f4af80b7e34ec6a1233894c71ef943", "groupName": "我的财富"}
返回值：
<200> {"groupId": "65f4af80b7e34ec6a1233894c71ef456"}
<400> {errorMessage: "请输入组名/组名已存在/分组已达上限"}

--------------------------------------------------[删除分组]
deleteGroup
删除 <groups> 里的分组后，自动删除所有相关受邀理财师的 <grouped> 中的此分组 id。
参数：
{"adviserId": "16f4af80b7e34ec6a1233894c71ef943","groupId": "65f4af80b7e34ec6a1233894c71ef456"}
返回值：
<200> 正常
<400> {errorMessage: "找不到改组"}

--------------------------------------------------[修改分组]
updateGroup
更改 <groups> 中的分组的名称。
参数：
{"adviserId": "16f4af80b7e34ec6a1233894c71ef943","groupId": "65f4af80b7e34ec6a1233894c71ef456", "groupName": "我的客户"}
返回值：
<200> 正常
<400> {errorMessage: "找不到改组"}

--------------------------------------------------[添加组员]
addGroupMembers
向指定的组里添加成员。更改 <grouped> 字段。
参数：
{"adviserId": "16f4af80b7e34ec6a1233894c71ef943",
"groupId": "65f4af80b7e34ec6a1233894c71ef456", 
"members": 
["0003fce75cd145ceaf1ac2d721a5f78d",
"0007f05ecee24a2d9d5d1750c8126217",
"00080a31f9fd4c9b8e4878c350da8d4f",
 ...]}
返回值：
<200> 正常
<400> {errorMessage: "创建分组失败"}

--------------------------------------------------[删除组员]
deleteGroupMembers
在指定的组里删除成员。匹配 <grouped> 字段，移除对应的 groupId。
参数：
#warning 同时删除多个组成员
{"adviserId": "16f4af80b7e34ec6a1233894c71ef943",
"groupId": "65f4af80b7e34ec6a1233894c71ef456", 
"members": 
["0003fce75cd145ceaf1ac2d721a5f78d", "0007f05ecee24a2d9d5d1750c8126217","00080a31f9fd4c9b8e4878c350da8d4f" ...]
}
返回值：
<200> 正常
<400> {errorMessage: "删除组员失败"}

--------------------------------------------------[修改备注]
updateMemos
修改 <memo> 的值。
参数：
[{"adviserId": "0003fce75cd145ceaf1ac2d721a5f78d", "memo": "修改备注"}, ...]
返回值：
<200> 正常
<400> {errorMessage: "修改备注失败"}