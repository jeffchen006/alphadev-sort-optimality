# n=5 model=out iset=I1 prefix14_class=357
cmp P0, P2
cmovle S0, P2
cmovg S0, P0
cmovg P0, P2
mov S2, P1
cmp P1, P3
mov S1, P0
cmovge P1, P3
cmovg P3, S2
cmp P1, P0
cmovl P0, P1
mov S2, P3
cmovl P1, S1
cmp S0, P3
