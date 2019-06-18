ng.module(
	"ng.lib.app2d.font",
	"ng.lib.app2d.base"
)
function ng.app2d.fontDrawChar(char, line)
if char == 62 then
line(13,15,13,13)
line(13,13,3,3)
line(13,15,3,25)
return 17
end
if char == 82 then
line(1,1,9,1)
line(9,1,13,5)
line(13,5,13,11)
line(13,11,9,15)
line(9,15,13,19)
line(13,19,13,21)
line(9,15,1,15)
line(1,15,1,21)
line(1,15,1,1)
return 17
end
if char == 127 then
line(1,17,7,5)
line(7,5,13,17)
line(1,17,1,25)
line(1,25,13,25)
line(13,25,13,17)
return 17
end
if char == 91 then
line(1,1,5,1)
line(1,1,1,27)
line(1,27,5,27)
return 17
end
if char == 86 then
line(1,1,7,21)
line(7,21,13,1)
return 17
end
if char == 35 then
line(3,7,3,11)
line(3,11,1,11)
line(11,11,3,11)
line(11,11,11,7)
line(11,11,13,11)
line(11,11,11,17)
line(11,17,13,17)
line(11,17,3,17)
line(3,17,3,11)
line(3,17,1,17)
line(11,21,11,17)
line(3,17,3,21)
return 17
end
if char == 93 then
line(13,1,9,1)
line(13,1,13,27)
line(13,27,9,27)
return 17
end
if char == 69 then
line(1,1,13,1)
line(1,1,1,9)
line(1,9,13,9)
line(1,9,1,21)
line(1,21,13,21)
return 17
end
if char == 90 then
line(1,1,13,1)
line(13,1,13,5)
line(13,5,1,17)
line(1,17,1,21)
line(1,21,13,21)
return 17
end
if char == 111 then
line(5,9,9,9)
line(9,9,13,13)
line(1,13,5,9)
line(1,13,1,17)
line(1,17,5,21)
line(5,21,9,21)
line(9,21,13,17)
line(13,17,13,13)
return 17
end
if char == 44 then
line(1,25,5,21)
line(2,25,6,21)
line(7,21,3,25)
return 17
end
if char == 101 then
line(5,9,1,13)
line(1,17,5,21)
line(5,21,13,21)
line(1,17,1,15)
line(1,15,1,13)
line(1,15,13,15)
line(13,15,13,13)
line(13,13,9,9)
line(9,9,5,9)
return 17
end
if char == 42 then
line(5,5,7,3)
line(7,3,5,1)
line(7,3,9,5)
line(9,1,7,3)
return 17
end
if char == 105 then
line(1,21,1,9)
line(1,5,1,3)
return 5
end
if char == 116 then
line(7,9,13,9)
line(7,9,7,1)
line(7,9,7,19)
line(7,19,9,21)
line(9,21,13,21)
line(7,9,1,9)
return 17
end
if char == 59 then
line(7,5,5,5)
line(5,6,7,6)
line(7,7,5,7)
line(5,21,1,25)
line(6,21,2,25)
line(3,25,7,21)
return 17
end
if char == 71 then
line(13,9,7,9)
line(13,9,13,19)
line(13,19,11,21)
line(11,21,3,21)
line(3,21,1,19)
line(13,1,3,1)
line(3,1,1,3)
line(1,19,1,3)
return 17
end
if char == 46 then
line(3,23,1,21)
line(1,21,3,19)
line(3,19,5,21)
line(5,21,3,23)
line(3,23,3,21)
line(3,21,3,19)
line(3,21,5,21)
line(3,21,1,21)
return 9
end
if char == 51 then
line(9,9,1,9)
line(1,1,7,1)
line(7,1,9,3)
line(9,3,9,9)
line(9,9,9,19)
line(9,19,7,21)
line(1,21,7,21)
return 13
end
if char == 80 then
line(1,1,9,1)
line(9,1,13,5)
line(13,5,13,11)
line(13,11,9,15)
line(9,15,1,15)
line(1,15,1,1)
line(1,15,1,21)
return 17
end
if char == 120 then
line(1,21,7,15)
line(7,15,1,9)
line(13,9,7,15)
line(7,15,13,21)
return 17
end
if char == 96 then
line(1,1,3,7)
return 17
end
if char == 88 then
line(1,21,7,11)
line(7,11,13,21)
line(13,1,7,11)
line(7,11,1,1)
return 17
end
if char == 58 then
line(3,21,5,21)
line(5,22,3,22)
line(3,23,5,23)
line(5,5,3,5)
line(3,6,5,6)
line(5,7,3,7)
return 9
end
if char == 118 then
line(1,9,7,21)
line(13,9,7,21)
return 17
end
if char == 126 then
line(1,13,3,11)
line(3,11,5,11)
line(5,11,7,13)
line(7,15,9,17)
line(9,17,11,17)
line(11,17,13,15)
line(7,13,7,15)
return 17
end
if char == 124 then
line(7,1,7,27)
return 17
end
if char == 55 then
line(7,1,9,3)
line(1,1,7,1)
line(9,3,9,21)
return 13
end
if char == 40 then
line(3,3,5,1)
line(5,23,3,21)
line(3,3,1,10)
line(3,21,1,14)
line(1,10,1,14)
return 9
end
if char == 95 then
line(1,27,13,27)
return 17
end
if char == 38 then
line(5,3,9,9)
line(9,9,7,15)
line(7,15,11,23)
line(13,27,13,25)
line(13,25,11,23)
line(11,23,13,21)
line(13,21,13,19)
line(11,23,9,25)
line(9,25,5,25)
line(5,25,3,23)
line(3,23,3,21)
line(3,21,5,17)
line(5,17,7,15)
line(5,17,1,9)
line(1,9,5,3)
return 17
end
if char == 34 then
line(3,1,3,11)
line(5,1,5,7)
line(4,1,4,9)
line(9,1,9,11)
line(10,9,10,1)
line(11,1,11,7)
return 17
end
if char == 75 then
line(1,1,1,11)
line(13,1,3,11)
line(3,11,13,21)
line(1,21,1,11)
line(1,11,3,11)
return 17
end
if char == 94 then
line(7,1,3,5)
line(7,1,11,5)
return 17
end
if char == 67 then
line(1,5,5,1)
line(5,1,13,1)
line(1,5,1,17)
line(1,17,5,21)
line(5,21,13,21)
return 17
end
if char == 92 then
line(1,1,13,27)
return 17
end
if char == 119 then
line(1,9,1,19)
line(1,19,3,21)
line(3,21,5,21)
line(5,21,7,19)
line(7,19,9,21)
line(9,21,11,21)
line(11,21,13,19)
line(13,19,13,9)
line(7,19,7,15)
return 17
end
if char == 47 then
line(13,1,1,27)
return 17
end
if char == 109 then
line(7,21,7,11)
line(7,11,5,9)
line(7,11,9,9)
line(9,9,11,9)
line(11,9,13,11)
line(1,11,3,9)
line(3,9,5,9)
line(1,11,1,21)
line(13,21,13,11)
return 17
end
if char == 85 then
line(1,1,1,19)
line(1,19,3,21)
line(3,21,11,21)
line(11,21,13,19)
line(13,19,13,1)
return 17
end
if char == 117 then
line(1,9,1,17)
line(1,17,5,21)
line(13,9,13,17)
line(13,17,9,21)
line(9,21,5,21)
line(13,17,13,21)
return 17
end
if char == 123 then
line(5,17,5,23)
line(5,11,5,5)
line(5,5,7,3)
line(7,25,5,23)
line(5,11,3,13)
line(3,13,3,15)
line(3,15,5,17)
return 17
end
if char == 54 then
line(1,9,1,3)
line(1,3,3,1)
line(7,21,9,19)
line(9,19,9,11)
line(9,11,7,9)
line(7,9,1,9)
line(1,9,1,19)
line(1,19,3,21)
line(7,21,3,21)
line(7,1,3,1)
line(7,1,9,3)
return 13
end
if char == 53 then
line(1,9,1,3)
line(1,3,3,1)
line(3,1,9,1)
line(7,21,9,19)
line(9,19,9,11)
line(9,11,7,9)
line(7,9,1,9)
line(1,21,7,21)
return 13
end
if char == 100 then
line(13,9,5,9)
line(5,9,1,13)
line(1,13,1,17)
line(1,17,5,21)
line(5,21,13,21)
line(13,21,13,9)
line(13,9,13,1)
return 17
end
if char == 78 then
line(1,21,1,1)
line(1,1,13,21)
line(13,21,13,1)
return 17
end
if char == 64 then
line(1,5,5,1)
line(5,1,9,1)
line(9,1,13,5)
line(13,5,13,9)
line(13,9,7,9)
line(7,9,5,11)
line(5,11,5,19)
line(5,19,7,21)
line(7,21,11,21)
line(11,21,13,19)
line(13,19,13,9)
line(1,5,1,23)
line(1,23,5,27)
line(5,27,11,27)
line(11,27,13,25)
return 17
end
if char == 56 then
line(1,3,3,1)
line(7,21,9,19)
line(9,19,9,11)
line(9,11,7,9)
line(1,19,3,21)
line(7,21,3,21)
line(7,1,3,1)
line(7,1,9,3)
line(7,9,3,9)
line(7,9,9,7)
line(9,7,9,3)
line(1,19,1,11)
line(1,11,3,9)
line(3,9,1,7)
line(1,7,1,3)
return 13
end
if char == 32 then
return 17
end
if char == 43 then
line(7,7,7,11)
line(7,11,7,15)
line(7,11,3,11)
line(7,11,11,11)
return 17
end
if char == 63 then
line(7,19,7,21)
line(3,3,5,1)
line(5,1,9,1)
line(9,1,13,5)
line(13,5,13,7)
line(13,7,9,11)
line(9,11,7,11)
line(5,21,7,23)
line(7,23,9,21)
line(9,21,7,19)
line(7,19,5,21)
line(5,21,7,21)
line(7,21,9,21)
line(7,21,7,23)
line(7,11,7,15)
return 17
end
if char == 103 then
line(13,9,5,9)
line(5,9,1,13)
line(1,13,1,17)
line(1,17,5,21)
line(5,21,13,21)
line(13,9,13,21)
line(13,21,13,25)
line(13,25,11,27)
line(11,27,3,27)
line(3,27,1,25)
return 17
end
if char == 48 then
line(3,1,1,3)
line(3,1,7,1)
line(7,1,9,3)
line(9,19,7,21)
line(7,21,3,21)
line(3,21,1,19)
line(1,3,1,7)
line(9,19,9,15)
line(9,15,1,7)
line(1,7,1,19)
line(9,15,9,3)
return 13
end
if char == 122 then
line(1,9,13,9)
line(13,9,13,11)
line(13,11,9,15)
line(9,15,5,15)
line(5,15,1,19)
line(1,19,1,21)
line(1,21,13,21)
return 17
end
if char == 114 then
line(1,13,5,9)
line(5,9,13,9)
line(1,13,1,21)
return 17
end
if char == 72 then
line(1,1,1,9)
line(1,9,13,9)
line(13,9,13,1)
line(13,9,13,21)
line(1,21,1,9)
return 17
end
if char == 45 then
line(11,11,3,11)
return 17
end
if char == 76 then
line(1,1,1,21)
line(1,21,13,21)
return 17
end
if char == 68 then
line(1,1,7,1)
line(7,1,13,7)
line(13,7,13,15)
line(13,15,7,21)
line(7,21,1,21)
line(1,21,1,1)
return 17
end
if char == 113 then
line(5,9,9,9)
line(9,9,13,13)
line(1,13,5,9)
line(13,13,13,21)
line(13,21,13,27)
line(13,21,5,21)
line(5,21,1,17)
line(1,17,1,13)
return 17
end
if char == 65 then
line(1,5,5,1)
line(1,9,1,5)
line(1,9,1,21)
line(5,1,9,1)
line(13,21,13,9)
line(13,9,13,5)
line(13,5,9,1)
line(1,9,13,9)
return 17
end
if char == 115 then
line(13,9,5,9)
line(5,9,1,13)
line(1,13,3,15)
line(3,15,11,15)
line(11,15,13,17)
line(13,17,9,21)
line(9,21,1,21)
return 17
end
if char == 50 then
line(1,3,3,1)
line(9,21,1,21)
line(1,21,1,11)
line(1,11,3,9)
line(3,9,7,9)
line(7,9,9,7)
line(9,7,9,3)
line(9,3,7,1)
line(7,1,3,1)
return 13
end
if char == 77 then
line(1,21,1,1)
line(1,1,7,7)
line(7,7,13,1)
line(13,1,13,21)
return 17
end
if char == 79 then
line(1,3,3,1)
line(3,1,11,1)
line(11,1,13,3)
line(13,3,13,19)
line(13,19,11,21)
line(11,21,3,21)
line(3,21,1,19)
line(1,19,1,3)
return 17
end
if char == 97 then
line(1,11,3,9)
line(3,9,11,9)
line(11,9,13,11)
line(13,11,13,15)
line(13,15,3,15)
line(3,15,1,17)
line(1,17,1,19)
line(1,19,3,21)
line(3,21,13,21)
line(13,21,13,15)
return 17
end
if char == 89 then
line(1,1,7,13)
line(7,13,7,21)
line(7,13,13,1)
return 17
end
if char == 106 then
line(7,5,7,3)
line(7,19,7,9)
line(7,19,5,21)
line(5,21,3,21)
line(3,21,1,19)
return 11
end
if char == 74 then
line(13,1,13,17)
line(13,17,9,21)
line(9,21,1,21)
return 17
end
if char == 57 then
line(1,3,3,1)
line(7,21,9,19)
line(1,19,3,21)
line(7,21,3,21)
line(7,1,3,1)
line(7,1,9,3)
line(3,9,1,7)
line(1,7,1,3)
line(3,9,9,9)
line(9,3,9,9)
line(9,19,9,9)
return 13
end
if char == 110 then
line(5,9,9,9)
line(9,9,13,13)
line(13,21,13,13)
line(1,21,1,13)
line(1,13,1,9)
line(1,13,5,9)
return 17
end
if char == 125 then
line(7,3,9,5)
line(9,5,9,11)
line(9,17,9,23)
line(9,23,7,25)
line(9,17,11,15)
line(11,15,11,13)
line(11,13,9,11)
return 17
end
if char == 33 then
line(3,1,3,15)
line(1,13,1,1)
line(2,14,2,1)
line(3,19,3,21)
line(3,21,3,23)
line(1,21,3,21)
line(3,21,5,21)
line(5,21,3,19)
line(3,19,1,21)
line(1,21,3,23)
line(3,23,5,21)
return 9
end
if char == 81 then
line(1,3,3,1)
line(3,1,11,1)
line(11,1,13,3)
line(13,3,13,17)
line(13,17,11,19)
line(11,19,9,21)
line(13,21,11,19)
line(11,19,9,17)
line(9,21,3,21)
line(3,21,1,19)
line(1,19,1,3)
return 17
end
if char == 87 then
line(13,1,13,21)
line(13,21,7,15)
line(7,15,1,21)
line(1,21,1,1)
return 17
end
if char == 41 then
line(1,1,3,3)
line(3,3,5,9)
line(1,23,3,21)
line(3,21,5,15)
line(5,15,5,9)
return 9
end
if char == 66 then
line(1,9,1,1)
line(1,21,1,9)
line(1,1,11,1)
line(11,1,13,3)
line(13,3,13,5)
line(9,9,13,5)
line(1,9,9,9)
line(9,9,13,13)
line(13,13,13,19)
line(13,19,11,21)
line(1,21,11,21)
return 17
end
if char == 37 then
line(13,1,1,27)
line(1,5,3,3)
line(13,23,11,25)
line(11,25,9,25)
line(9,25,7,23)
line(7,5,5,3)
line(5,3,3,3)
line(1,5,1,11)
line(1,11,3,13)
line(3,13,5,13)
line(5,13,7,11)
line(7,11,7,5)
line(7,23,7,17)
line(7,17,9,15)
line(9,15,11,15)
line(11,15,13,17)
line(13,17,13,23)
return 17
end
if char == 102 then
line(5,3,7,1)
line(7,1,13,1)
line(5,9,13,9)
line(5,3,5,9)
line(5,21,5,9)
line(5,9,1,9)
return 17
end
if char == 121 then
line(7,23,3,27)
line(3,27,1,27)
line(1,9,7,23)
line(7,23,13,9)
return 17
end
if char == 112 then
line(5,9,9,9)
line(9,9,13,13)
line(1,13,5,9)
line(9,21,13,17)
line(13,17,13,13)
line(1,13,1,21)
line(1,21,9,21)
line(1,21,1,27)
return 17
end
if char == 108 then
line(1,1,1,19)
line(1,19,3,21)
line(3,21,7,21)
return 11
end
if char == 73 then
line(1,1,7,1)
line(7,1,13,1)
line(7,1,7,21)
line(1,21,7,21)
line(7,21,13,21)
return 17
end
if char == 36 then
line(7,1,7,5)
line(7,5,11,5)
line(7,5,5,5)
line(5,5,1,9)
line(1,9,1,11)
line(1,11,5,15)
line(5,15,7,15)
line(7,15,7,5)
line(7,15,11,15)
line(11,15,13,17)
line(13,17,13,19)
line(13,19,9,23)
line(9,23,7,23)
line(7,23,7,15)
line(7,23,7,27)
line(7,23,3,23)
return 17
end
if char == 83 then
line(13,1,3,1)
line(3,1,1,3)
line(1,3,1,7)
line(1,7,3,9)
line(3,9,11,9)
line(11,9,13,11)
line(13,11,13,19)
line(13,19,11,21)
line(11,21,1,21)
return 17
end
if char == 163 then
line(5,5,7,2)
line(7,2,10,1)
line(10,1,13,2)
line(5,11,3,11)
line(5,11,5,5)
line(13,2,15,4)
line(5,11,11,11)
line(17,21,1,21)
line(5,11,5,17)
line(5,17,1,21)
return 21
end
if char == 49 then
line(5,1,1,5)
line(5,1,5,21)
line(5,21,1,21)
line(5,21,9,21)
return 13
end
if char == 98 then
line(1,1,1,9)
line(1,9,9,9)
line(9,9,13,13)
line(13,13,13,17)
line(13,17,9,21)
line(9,21,1,21)
line(1,21,1,9)
return 17
end
if char == 84 then
line(1,1,7,1)
line(7,1,13,1)
line(7,1,7,21)
return 17
end
if char == 107 then
line(1,1,1,15)
line(1,15,1,21)
line(1,15,3,15)
line(3,15,9,13)
line(3,15,9,17)
line(9,17,13,21)
line(9,13,13,9)
return 17
end
if char == 52 then
line(9,9,3,9)
line(3,9,1,7)
line(1,7,1,1)
line(9,9,9,1)
line(9,9,9,21)
return 13
end
if char == 65533 then
line(1,1,1,17)
line(1,17,5,21)
line(5,21,9,21)
line(9,21,13,17)
line(13,17,13,1)
line(17,11,25,11)
line(21,7,21,15)
line(106,1,106,27)
line(106,27,1,27)
return 29
end
if char == 60 then
line(11,3,1,13)
line(1,13,1,15)
line(1,15,11,25)
return 17
end
if char == 128640 then
line(27,3,23,3)
line(27,3,27,7)
line(27,7,25,15)
line(23,3,15,5)
line(15,5,7,13)
line(25,15,17,23)
line(17,23,13,25)
line(7,13,5,17)
line(1,17,5,17)
line(13,25,13,29)
line(13,25,5,17)
line(21,9,25,5)
line(21,9,18,6)
line(18,6,25,5)
line(5,21,1,25)
line(9,25,5,29)
line(13,24,11,22)
line(11,22,14,23)
line(14,23,12,21)
line(14,21,15,20)
line(15,20,15,22)
line(15,22,13,22)
line(13,22,13,20)
line(13,20,14,20)
line(14,19,16,21)
line(16,21,17,20)
line(16,20,15,19)
line(15,19,15,18)
line(15,18,16,18)
line(16,18,16,19)
line(16,19,15,19)
line(18,19,17,18)
line(17,18,16,17)
line(17,18,17,17)
line(17,18,18,18)
line(18,17,18,15)
line(18,15,19,15)
line(18,17,20,17)
line(20,17,20,15)
line(20,15,19,16)
line(17,13,10,20)
line(10,20,7,17)
line(7,17,14,10)
line(14,10,17,13)
line(15,9,17,7)
line(20,10,18,12)
line(18,12,15,9)
line(17,7,20,10)
return 31
end
if char == 70 then
line(1,1,13,1)
line(1,1,1,9)
line(1,9,13,9)
line(1,9,1,21)
return 17
end
if char == 104 then
line(1,1,1,9)
line(1,9,9,9)
line(9,9,13,13)
line(13,13,13,21)
line(1,9,1,21)
return 17
end
if char == 61 then
line(3,9,11,9)
line(3,19,11,19)
return 17
end
if char == 99 then
line(13,9,5,9)
line(5,9,1,13)
line(1,13,1,17)
line(1,17,5,21)
line(5,21,13,21)
return 17
end
if char == 39 then
line(5,1,1,7)
return 5
end
end
