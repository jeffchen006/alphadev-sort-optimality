# n=5 model=out iset=I1 prefix14_class=1180
cmp P1, P0
cmovle S2, P1
cmovl P1, P0
cmovl P0, S2
mov S0, P3
cmp S0, P2
mov S2, P0
cmovle S0, P2
cmovg P3, P2
cmp P1, S0
cmovge P2, P1
cmovge P1, S0
cmovg S0, P2
cmp P0, P3
