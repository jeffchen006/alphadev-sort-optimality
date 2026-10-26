# n=5 model=out iset=I1 prefix14_class=9053
mov S0, P2
mov S2, P1
cmp P0, S2
cmovl S2, P0
cmovle P0, P1
cmp P3, P2
cmovg S0, P3
cmovle P2, P3
cmp S0, P0
cmovle P1, S0
cmovle S0, P0
mov P3, S2
cmovl P0, P1
cmp S2, P2
