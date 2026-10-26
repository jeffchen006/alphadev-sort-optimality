# n=5 model=out iset=I1 prefix14_class=5182
mov S1, P2
cmp S1, P1
cmovle S1, P1
cmovle P1, P2
cmp P3, P0
cmovl P2, P0
cmovle P0, P3
cmovl P3, P2
cmp P0, P1
cmovg P2, P0
cmovg P0, P1
mov P0, S1
cmovg P1, P2
cmp P3, P0
