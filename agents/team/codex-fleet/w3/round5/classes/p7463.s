# n=5 model=out iset=I1 prefix14_class=7463
mov S0, P2
cmp P1, S0
cmovle P2, P1
mov S2, P3
cmovg S0, P1
cmp P0, P3
cmovle P3, P0
cmovl P0, S2
cmp P2, P3
mov S2, P2
cmovle P2, P3
cmovl P3, S2
cmp P0, S0
cmovg S2, S0
