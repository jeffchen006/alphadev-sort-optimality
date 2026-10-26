# n=5 model=out iset=I1 prefix14_class=7092
mov S0, P0
cmp P1, P0
cmovg S0, P1
mov S1, P2
cmovg P1, P0
cmp P2, P3
cmovg P2, P3
cmovg P3, S1
cmp P2, P1
cmovge S2, P1
cmovge P1, P2
cmovle S2, P2
cmp S0, P3
cmovl P0, P3
