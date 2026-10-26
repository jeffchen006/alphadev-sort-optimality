# n=5 model=out iset=I1 prefix14_class=6169
cmp P2, P0
mov S2, P2
mov S0, P1
cmovg S2, P0
cmovl P2, P0
cmp P3, S0
cmovle S0, P3
cmovge P1, P3
cmovge P3, S0
cmp P2, P1
cmovg S1, P1
cmovg P1, P2
cmovg P2, S1
cmp S2, P3
