# n=5 model=out iset=I1 prefix14_class=1694
cmp P0, P2
cmovle S2, P2
cmovl P2, P0
mov S0, P3
cmovg S2, P0
cmp P1, S0
cmovl P3, P1
cmovle P1, S0
mov P0, P3
cmp P2, P3
cmovl P0, P2
cmovge P3, P2
cmp S2, P1
mov P0, P1
