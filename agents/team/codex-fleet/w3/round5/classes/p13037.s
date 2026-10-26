# n=5 model=out iset=I1 prefix14_class=13037
mov S1, P3
cmp P0, P3
cmovg S1, P0
cmovl P3, P0
cmp P1, P2
cmovle P0, P1
cmovl P1, P2
cmovle P2, P0
mov S0, P2
cmp S0, P3
cmovle P2, P3
cmovle P3, S0
mov P3, P2
cmp P1, S1
