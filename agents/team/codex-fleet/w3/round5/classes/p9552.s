# n=5 model=out iset=I1 prefix14_class=9552
cmp P0, P2
cmovle S0, P0
cmovle P0, P2
mov S1, P3
cmovg S0, P2
cmp P3, P1
cmovle S1, P1
cmovge P3, P1
mov S2, P3
cmp S0, S2
cmovg P3, S0
cmovl S2, S0
cmp S1, P0
cmovl S0, S1
