# n=5 model=out iset=I1 prefix14_class=5400
mov S2, P2
cmp P0, S2
cmovg S2, P0
cmovg P0, P2
mov S0, P1
cmp P1, P3
cmovle S0, P3
cmovl P3, P1
cmp P3, P0
cmovg P1, P3
cmovge P3, P0
cmovg P0, P1
cmp S2, S0
cmovl P2, S0
