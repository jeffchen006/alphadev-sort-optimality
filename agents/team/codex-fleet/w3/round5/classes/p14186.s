# n=5 model=out iset=I1 prefix14_class=14186
cmp P0, P3
mov S0, P2
cmovle S2, P3
cmovg S2, P0
cmovl P3, P0
cmp S0, P1
cmovl P2, P1
cmovg S0, P1
cmp P2, S2
cmovge P1, P2
cmovg P2, S2
cmovg S2, P1
cmp S0, P3
mov S2, P3
