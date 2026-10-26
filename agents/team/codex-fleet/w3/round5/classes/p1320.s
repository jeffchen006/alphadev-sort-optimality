# n=5 model=out iset=I1 prefix14_class=1320
mov S2, P0
mov S0, P3
cmp P1, S0
cmovg S0, P1
cmovl P3, P1
cmovl P1, S0
cmp S2, P2
cmovge P0, P2
cmovg P2, S2
cmp P2, P1
cmovge P1, P2
cmovle S0, P2
cmp P0, P3
cmovg P2, S0
