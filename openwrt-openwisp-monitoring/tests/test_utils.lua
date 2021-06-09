package.path = package.path .. ";../?.lua"

local luaunit = require('luaunit')

local utils = require('../utils')

function testSplitFunction()
	-- When pattern is present
	luaunit.assertEquals(utils.split("OpenWISP","n"), {"Ope", "WISP"})
	luaunit.assertEquals(utils.split("OpenWISP","WISP"), {"Open"})

	-- When pattern is not available
	luaunit.assertEquals(utils.split("OpenWISP","a"), {"OpenWISP"})
end

function testHasValue()
	-- When value is present
	luaunit.assertEquals(utils.has_value({2,4,5},4), true)
	luaunit.assertEquals(utils.has_value({1,2,3,7,9},9), true)

	-- When value is not present
	luaunit.assertEquals(utils.has_value({2,4,5},3), false)
	luaunit.assertEquals(utils.has_value({1,2,3,7,9},8), false)

end

function testStartsWith()
	-- When string starts with the substring given
	luaunit.assertEquals(utils.starts_with("OpenWISP", "Open"), true)
	luaunit.assertEquals(utils.starts_with("NetJSON", "Net"), true)

	-- when string doesn't starts with the substring given
	luaunit.assertEquals(utils.starts_with("OpenWISP", "Ov"), false)
end

function testTableEmpty()
	-- When table is empty
	luaunit.assertEquals(utils.is_table_empty(nil), true)
	luaunit.assertEquals(utils.is_table_empty({}), true)

	-- When table is not empty
	luaunit.assertEquals(utils.is_table_empty({1,2,3,4}), false)
	luaunit.assertEquals(utils.is_table_empty({"wireless", "wired", "system"}), false)
end

function testArrayConcat()
	luaunit.assertEquals(utils.array_concat({4,5,6},{1,2,3}), {1, 2, 3, 4, 5, 6})
	luaunit.assertEquals(utils.array_concat({"wireless"},{"wired"}), {"wired", "wireless"})
	luaunit.assertEquals(utils.array_concat({"system", "network"},{"firewall"}), {"firewall", "system", "network"})
end

function testDictMerge()
	luaunit.assertEquals(utils.dict_merge({['1']='OpenWISP'},{['3']='NetJSON'}),  {["1"]="OpenWISP", ["3"]="NetJSON"})
	luaunit.assertEquals(utils.dict_merge({['1']='OpenWISP'},{['1']='NetJSON'}),  {["1"]="OpenWISP"})
end

os.exit(luaunit.LuaUnit.run())
