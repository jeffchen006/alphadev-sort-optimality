# n=5 model=out iset=I1 prefix14_class=13980
mov S2, P0
cmp P1, P3
cmovle S0, P1
cmovl P1, P3
cmovl P3, S0
cmp S2, P2
cmovg S2, P2
cmovge P2, P0
cmovl P0, P2
cmp P1, P0
cmovg P2, P1
cmovl P0, P1
cmp S2, P3
cmovg S0, S2
