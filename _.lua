_={
	_ver="1.0.0",
	config={
		makeGlobal = true
	},
	modules={
		Instance={
			PrivImpl	=function(b)return function(c)c=c or{}local d=Instance.new(b)local e=nil;local f=nil;for g,h in pairs(c)do if type(g)=='string'then if g=='Parent'then e=h else d[g]=h end elseif type(g)=='number'then h.Parent=d elseif type(g)=='table'and g.__eventname then d[g.__eventname]:connect(h)elseif g==New then f=h end end;if f then f(d)end;if e then d.Parent=e end;return d end end,
			New			=nil,
			Event		=function(eventName)return {__eventname = eventName}end
		}
	},
	funcs={
		value		={[""]=[[return self._val]]},
		identity	={["val"]=[[return val]]},
		iter		={["list"]=[[if type(list)=="function"then return list else return coroutine.wrap(function()for i=1,#list do coroutine.yield(list[i]) end end) end]]},
		
		-- TABLE FILTERING
		_each		={["list, callback"]=[[for i in iter(list)do callback(i)end return list]]},
		_map		={["list, callback"]=[[local mapped={}for i in iter(list)do mapped[#mapped+1]=callback(i)end return mapped]]},
		_reduce		={["list, memo, callback"]=[[for i in iter(list)do memo=callback(memo, i)end return mapped]]},
		_detect		={["list, callback"]=[[for i in iter(list)do if callback(i)then return i end end]]},
		_select		={["list, callback"]=[[local selected={}for i in iter(list)do if callback(i)then selected[#selected+1]=i end end return selected]]},
		_reject		={["list, callback"]=[[local selected={}for i in iter(list)do if not callback(i)then selected[#selected+1]=i end end return selected]]},
		_all		={["list, callback"]=[[callback=callback or identity;for i in iter(list)do if not callback(i)then return false end end return true]]},
		_any		={["list, callback"]=[[callback=callback or identity;for i in iter(list)do if callback(i)then return true end end return false]]},
		_includes	={["list, value"]=[[for i in iter(list)do if i==value then return true end end return false]]},
		_invoke		={["list, nfunction, ..."]=[[local args={...};_each(list, function(i)i[nfunction](i, unpack(args))end)return list]]},
		_pluck		={["list, property"]=[[return _map(list, function(i)return i[property] end)]]},
		
		-- TABLE MANIPULATION
		_toarray	={["list"]=[[local arr={}for i in iter(list)do arr[#arr+1]=i end return arr]]},
		_reverse	={["list"]=[[local rev={}for i in iter(list)do table.insert(rev,1,i)end return rev]]},
		_sort		={["iter, compare"]=[[local arr=iter;if type(iter)=="function"then arr=_toarray(iter)end table.sort(arr,compare)return arr]]},
		_first		={["arr, n"]=[[if n==nil then return arr[1]else local first={}n=math.min(n,#array)for i=1,n do first[i]=arr[i]end end return first]]},
		_rest		={["arr, i"]=[[i=i or 2;local rest={}for j=i,#arr do rest[#rest+1]=arr[i]end return rest]]},
		_slice		={["arr, i, l"]=[[local sliced={}i=math.max(i,1)local e=math.min(i+l-1,#arr)for j=i,e do sliced[#sliced+1]=arr[i]end return sliced]]},
		_flatten	={["arr"]=[[local all={}for ele in iter(arr)do if type(ele)=="table"then local f_ele=_flatten(ele)_each(f_ele,function(e)all[#all+1]=e end) else all[#all+1]=ele end end return all]]},
		_push		={["arr, i"]=[[table.insert(arr,i)return arr]]},
		_pop		={["arr"]=[[return table.remove(arr)]]},
		_shift		={["arr"]=[[return table.remove(arr,1)]]},
		_unshift	={["arr, i"]=[[return table.insert(arr,1,i)]]},
		_join		={["arr, sep"]=[[return table.concat(arr,sep)]]},
		
		-- OBJECT FILTERING
		_keys		={["obj"]=[[local keys={}for k,_ in pairs(obj)do keys[#keys+1]=k end return keys]]},
		_values		={["obj"]=[[local vals={}for _,v in pairs(obj)do vals[#vals+1]=v end return vals]]},
		_extend		={["dest, src"]=[[for k,v in pairs(src)do dest[k]=v end return dest]]},
		_isempty	={["obj"]=[[return next(obj)==nil]]},
		_isequal	={["o1,o2,ignore_mt"]=[[local t1=type(o1)local t2=type(o2)if t1~=t2 then return false end if t1~="table" then return o1==02 end local mt=getmetatable(o1)if not ignore_mt and mt and mt.__eq then return o1==o2 end for k1,v1 in pairs(o1)do local v2=o2[k1]if v2==nil or not _isequal(v1,v2,ignore_mt) then return false end end for k2,v2 in pairs(o2)do local v1=o1[k2]if v1==nil then return false end end return true]]},
		
		-- MATH
		_min		={["list, callback"]=[[callback=callback or identity;return _reduce(list,{item=nil,value=nil},function(min,item)if min.item==nil then min.item=item;min.value=callback(item)else local value=callback(item)if value<min.value then min.item=item;min.value=value end end return min end).item]]},
		_max		={["list, callback"]=[[callback=callback or identity;return _reduce(list,{item=nil,value=nil},function(max,item)if max.item==nil then max.item=item;max.value=callback(item)else local value=callback(item)if value>max.value then max.item=item;max.value=value end end return max end).item]]},
		
		-- COMPOSITION
		_compose	={["..."]=[[local function callf(funcs,...)if #funcs>1 then return funcs[1](callf(_rest(funcs), ...))else return funcs[1](...)end end local funcs={...}return function(...)return callf(funcs, ...)end]]},
		_wrap		={["func, wrapper"]=[[return function(...)return wrapper(func, ...)end]]},
		
		-- OUTPUT
		_print		={["msg, ..."]=[[print(string.format(msg,...))]]},
		_warn		={["msg, ..."]=[[warn(string.format(msg,...))]]},
		
		-- MISC
		_functions	={[""]=[[return _keys(_.funcs)]]},
		_debounce	={["db, fn"]=[[_wrap(fn, function(func, ...)if not db then db=true;func(...)db=false end end)]]}
	},
	compiled={}
}

_.__index=_
_.modules.Instance.New = setmetatable({}, {__call = function(tb, ...) return _.modules.Instance.PrivImpl(...) end})

for f,d in pairs(_.funcs) do
	for v,e in pairs(d) do
		if _.config.makeGlobal then
			loadstring(assert(string.format("function %s(%s)%s end",f,v,e)))()
		end
		loadstring(assert(string.format("function _.compiled.%s(%s)%s end",f,v,e)))()
	end
end

function _:_new(val, chained)
	return setmetatable({ _val = val, chained = chained or false }, self)
end
function _:_chain()
	self.chained=true
	return self
end

coroutine.wrap(function()
	local function a(b)
		local c=false
		if getmetatable(b)==_ then
			c=b.chained
			b=b._val
		end
		return b,c
	end

	local function d(e,c)
		if c then
			e=_(e,true)
		end
		return e
	end
	for f,g in pairs(_.compiled) do
		_[f]=function(b,...)
			do
				local h,c=a(b)
				return d(g(h,...),c)
			end
		end
	end
end)()

setmetatable(_, {__call=function(_,val)return _:_new(val)end})
New = _.modules.Instance.New;Event = _.modules.Instance.Event
_print("\n%s\n_Lib V%s - READY\nCreated by Plutonus.\n\nExposed Functions:\n%s\n\nSession Settings:\n%s\n%s", "> "..string.rep("- ",40).."- <", _._ver, _join(_functions(),", "), _join(_(_.config):_chain():_keys():_map(function(i)return string.format("%s = %s",i,tostring(_.config[i])) end), "\n"), "> "..string.rep("- ",40).."- <")