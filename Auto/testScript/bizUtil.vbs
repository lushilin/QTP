function menuSelect(menuName)
	logPrint("开始进入功能："&menuName)
	Set curPage=Browser("creationtime:=0").Page("index:=0")
	logPrint("CurrentPage :"&curPage )
	menu=split(menuName,"-")
	curPage.WebElement("innerhtml:="&menu(0)).Click
	if curPage.WebButton("name:=确 定").exist(2) then
		curPage.WebButton("name:=确 定").Click
	end if
'依次把每级菜单找出来，并且找到它们的code，特别是最后一级的菜单 ，可能会找到多个对象 
'从第一级开始逐级查找下级菜单 ，直到找到每一级的唯一的菜单
For i= 1 to UBound(menu)
	Set menuDesc = description.Create()
	menuDesc("text").Value=menu(i)
	menuDesc("micclass").Value = "Link"
	if curPage.Exist(1) then
		label = 0
		While(label = 0)
			Set menuLists = curPage.ChildObjects(menuDesc) 	
			NumberOfLists = menuLists.Count() 
			logPrint("NumberOfLists = menuLists.Count() :"&NumberOfLists )
			If NumberOfLists=1 Then
				menu(i)=menuLists.Item(0).GetROProperty("html id")
				label = label + 1
			elseif NumberOfLists>1 then
				For j=0 to NumberOfLists
					tempCode=menuLists.Item(j).GetROProperty("html id")
					If instr(tempCode,menu(i-1))>0 Then
						menu(i)=tempCode
						label = label + 1
						Exit For
					End If
				Next
			else
				logPrint("菜单"&menu(i)&"没有找到")			
			End If
		Wend
		curPage.Link("html id:="&menu(i)).Click
	else
		logPrint("curPage not Exist !!!!!")
	end if
	Set menuLists = nothing
	Set menuDesc = nothing
Next
	Set curPage = nothing
End function 
