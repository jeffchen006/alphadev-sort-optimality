# n=5 model=out iset=I1 prefix14_class=12290
mov S0, P2
cmp P0, S0
cmovl P2, P0
mov S2, P2
cmovg S0, P0
cmp P1, P3
cmovge P0, P3
cmovge P3, P1
cmovg P1, P0
cmp S2, P1
cmovge P2, P1
cmovg P1, S2
cmp P3, S0
cmovle S1, P3
