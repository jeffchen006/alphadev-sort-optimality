# n=5 model=out iset=I1 prefix14_class=754
cmp P2, P0
mov S2, P0
mov S1, P1
cmovle S2, P2
cmovl P2, P0
cmp S1, P3
cmovl P1, P3
mov P0, P1
cmovg S1, P3
cmp P1, P2
cmovle P1, P2
cmovl P2, P0
cmp S1, S2
mov S0, S1
